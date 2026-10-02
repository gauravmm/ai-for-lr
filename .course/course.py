#!/usr/bin/env python3
"""Course enrollment and consent-scoped Claude capture. Python standard library only."""
from __future__ import annotations

import argparse
import contextlib
import datetime as dt
import fcntl
import hashlib
import json
import os
from pathlib import Path
import random
import re
import shlex
import shutil
import sqlite3
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.parse
import urllib.request
import uuid

MAX_CHUNK = 512 * 1024
ID = re.compile(r"^[A-Za-z0-9_-]{1,128}$")
SKIP_DIRS = {".git", "node_modules", ".venv", "__pycache__", "output", "outputs", ".course-state"}
NOTICE = "Course login gives you access to ASTAR funded tokens, but submits your course conversations. Empty email skips."


def now():
    return dt.datetime.now(dt.timezone.utc).isoformat()


def timestamp(value):
    return dt.datetime.fromisoformat(value.replace("Z", "+00:00")).timestamp()


def atomic(path, data, raw=False):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    if path.is_symlink():
        raise ValueError("Refusing to overwrite a symbolic link")
    fd, name = tempfile.mkstemp(dir=path.parent, prefix=".write-")
    try:
        with os.fdopen(fd, "w") as out:
            if raw:
                out.write(data)
            else:
                json.dump(data, out, indent=2)
                out.write("\n")
            out.flush()
            os.fsync(out.fileno())
        os.replace(name, path)
        directory = os.open(path.parent, os.O_RDONLY)
        try:
            os.fsync(directory)
        finally:
            os.close(directory)
    finally:
        if os.path.exists(name):
            os.unlink(name)


def read_json(path, default=None):
    try:
        return json.loads(Path(path).read_text())
    except FileNotFoundError:
        return default


def read_settings(path):
    """Accept VS Code JSONC without treating comment markers inside strings as comments."""
    try:
        raw = Path(path).read_text()
    except FileNotFoundError:
        return {}, None
    output, index, quoted, escaped = [], 0, False, False
    while index < len(raw):
        char = raw[index]
        if quoted:
            output.append(char)
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                quoted = False
        elif char == '"':
            quoted = True
            output.append(char)
        elif raw[index:index + 2] == "//":
            end = raw.find("\n", index)
            index = len(raw) if end == -1 else end
            output.append("\n")
            continue
        elif raw[index:index + 2] == "/*":
            end = raw.find("*/", index + 2)
            if end == -1:
                raise ValueError("Invalid VS Code JSONC settings; fix the unclosed comment and retry course login.")
            index = end + 2
            output.append(" ")
            continue
        elif char == ",":
            # Trailing commas are removed in a second pass after comment removal.
            output.append(char)
        else:
            output.append(char)
        index += 1
    cleaned = "".join(output)
    output, quoted, escaped = [], False, False
    for index, char in enumerate(cleaned):
        if quoted:
            output.append(char)
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                quoted = False
        else:
            if char == '"':
                quoted = True
            if char == "," and cleaned[index + 1:].lstrip().startswith(("}", "]")):
                continue
            output.append(char)
    try:
        data = json.loads("".join(output))
    except ValueError:
        raise ValueError("Cannot parse VS Code settings; fix the JSONC syntax and retry course login.") from None
    if not isinstance(data, dict):
        raise ValueError("VS Code settings must contain an object")
    return data, raw


def safe_path(path, root):
    """Canonical containment plus rejection of every symlink component."""
    path, root = Path(path).absolute(), Path(root).absolute()
    try:
        relative = path.relative_to(root)
    except ValueError:
        return False
    current = root
    if root.is_symlink():
        return False
    for part in relative.parts:
        if part in {"..", "."}:
            return False
        current = current / part
        if current.is_symlink():
            return False
    return path.resolve().is_relative_to(root.resolve())


def activate(workspace):
    workspace = Path(workspace).resolve()
    result = subprocess.run(["git", "-C", str(workspace), "rev-parse", "--show-superproject-working-tree"],
                            capture_output=True, text=True)
    if result.returncode == 0 and result.stdout.strip():
        raise ValueError("Open the student repository as a standalone checkout; activation inside the parent submodule is refused.")
    digest = hashlib.sha256(str(workspace).encode()).hexdigest()[:20]
    journal_path = Path.home() / ".local/state/course" / digest / "activation.json"
    journal = read_json(journal_path)
    if not journal or journal.get("complete"):
        entries = []
        for directory, dirs, files in os.walk(workspace, followlinks=False):
            entries.extend(Path(directory) / name for name in dirs + files if name not in SKIP_DIRS)
            dirs[:] = [d for d in dirs if d not in SKIP_DIRS and not (Path(directory) / d).is_symlink()]
        destinations = {}
        renames = []
        tracked_result = subprocess.run(["git", "-C", str(workspace), "ls-files", "-z"], capture_output=True)
        tracked = set(tracked_result.stdout.decode().split("\0")) if tracked_result.returncode == 0 else None
        for path in entries:
            rel = path.relative_to(workspace)
            target = Path(*(p[:-8] if p.endswith(".student") else p for p in rel.parts))
            if any(not p or p in {".", ".."} for p in target.parts) or any(p == ".student" for p in rel.parts):
                raise ValueError(f"Unsafe template name: {rel}")
            if target in destinations:
                raise ValueError(f"Activation collision: {target}. Preserve your edits and resolve the duplicate first.")
            destinations[target] = rel
            if path.name.endswith(".student"):
                if path.is_symlink():
                    raise ValueError(f"Refusing symbolic-link template: {rel}")
                if tracked is not None and str(rel) not in tracked and not any(t.startswith(str(rel) + "/") for t in tracked):
                    continue
                renames.append(path)
        # Persist the complete preflighted plan before mutation. This also records ownership.
        operations = []
        for path in sorted(renames, key=lambda p: len(p.parts), reverse=True):
            stat = path.stat()
            operations.append({"source": str(path.relative_to(workspace)),
                               "target": str(path.with_name(path.name[:-8]).relative_to(workspace)),
                               "inode": stat.st_ino, "device": stat.st_dev, "done": False})
        journal = {"workspace": str(workspace), "operations": operations, "complete": False}
        atomic(journal_path, journal)
    count = 0
    for operation in journal["operations"]:
        if operation["done"]:
            continue
        source, target = workspace / operation["source"], workspace / operation["target"]
        if not safe_path(source, workspace) or not safe_path(target, workspace):
            raise ValueError("Activation journal contains an unsafe path")
        if source.exists():
            if target.exists():
                raise ValueError(f"Activation collision: {target.relative_to(workspace)}")
            source.rename(target)
        else:
            # A crash may occur after rename but before the progress commit.
            if not target.exists() or (target.stat().st_ino, target.stat().st_dev) != (operation["inode"], operation["device"]):
                raise ValueError("Activation interrupted and files changed; ask the instructor before recovering.")
        operation["done"] = True
        atomic(journal_path, journal)
        count += 1
    journal["complete"] = True
    atomic(journal_path, journal)
    return count


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        raise ValueError("Keyserver redirects are refused")


class Course:
    def __init__(self, workspace):
        self.workspace = Path(workspace).resolve()
        self.config = read_json(self.workspace / ".course/config.json")
        if not self.config:
            raise ValueError("Run course from the student repository root.")
        self.server = os.environ.get("COURSE_SERVER_URL", self.config["server"]).rstrip("/")
        parsed = urllib.parse.urlsplit(self.server)
        local = parsed.hostname in {"localhost", "127.0.0.1", "::1"}
        if parsed.scheme != "https" and not (parsed.scheme == "http" and local):
            raise ValueError("Keyserver requires HTTPS (HTTP is allowed only on loopback for tests).")
        if parsed.username or parsed.password or parsed.query or parsed.fragment:
            raise ValueError("Invalid keyserver address")
        digest = hashlib.sha256(str(self.workspace).encode()).hexdigest()[:20]
        self.home = Path.home() / ".local/state/course" / digest
        if self.home.resolve().is_relative_to(self.workspace):
            raise ValueError("Course credentials must be outside the workspace")
        self.home.mkdir(parents=True, exist_ok=True, mode=0o700)
        os.chmod(self.home, 0o700)
        self.path = self.home / "state.json"

    @contextlib.contextmanager
    def state(self, recover_editor=True):
        with (self.home / "lock").open("a") as lock:
            os.chmod(self.home / "lock", 0o600)
            fcntl.flock(lock, fcntl.LOCK_EX)
            data = read_json(self.path, {"installation_id": str(uuid.uuid4()), "active": None, "enrollments": {}})
            adapter_pending_path = self.home / "adapter-pending.json"
            adapter_pending = read_json(adapter_pending_path)
            if adapter_pending:
                if adapter_pending["enrollment_id"] not in data["enrollments"]:
                    self.remove_legacy_proxy_files(adapter_pending)
                adapter_pending_path.unlink()
            pending_path = self.home / "editor-pending.json"
            pending = read_json(pending_path)
            if pending and recover_editor:
                if pending["enrollment_id"] not in data["enrollments"]:
                    self.restore_editor({"editor_patches": pending["patches"]})
                pending_path.unlink()
            self.migrate_legacy_enrollments(data)
            yield data
            atomic(self.path, data)
            pending = read_json(pending_path)
            if pending and pending["enrollment_id"] in data["enrollments"]:
                pending_path.unlink()

    def request(self, path, body=None, enrollment=None):
        headers = {"Content-Type": "application/json", "Accept": "application/json", "User-Agent": "AI-for-CLM-Course/0.1"}
        if enrollment:
            headers["Authorization"] = "Bearer " + enrollment["upload_token"]
        server = enrollment.get("server", self.server) if enrollment else self.server
        req = urllib.request.Request(server + path, data=None if body is None else json.dumps(body).encode(), headers=headers)
        try:
            with urllib.request.build_opener(NoRedirect).open(req, timeout=15) as response:
                return json.load(response)
        except urllib.error.HTTPError as exc:
            # Never echo server bodies or request headers: they may contain a credential.
            raise ValueError(f"Keyserver returned HTTP {exc.code}; check your details or ask the instructor.") from None
        except (urllib.error.URLError, TimeoutError):
            raise ValueError("Keyserver is unavailable. Existing funded access is unchanged; uploads will retry.") from None

    @staticmethod
    def active(enrollment):
        return bool(enrollment and not enrollment.get("ended_at") and timestamp(enrollment["expires_at"]) > time.time())

    @staticmethod
    def legacy_endpoint(enrollment):
        endpoint = enrollment.get("inference_base_url", "").rstrip("/")
        return bool(enrollment.get("adapter") or enrollment.get("eip_api_key") or enrollment.get("eip_system_name")
                    or endpoint == "https://eip-uat-api.a-star.edu.sg/astar/aah")

    def remove_legacy_proxy_files(self, enrollment):
        """Deletion-only migration: old proxies observe config removal and terminate themselves."""
        identity = enrollment.get("enrollment_id", "")
        if not isinstance(identity, str) or not ID.fullmatch(identity):
            raise ValueError("Cannot migrate an invalid legacy enrollment identifier")
        directory = self.home / identity
        for name in ("adapter.json", "adapter-ready.json"):
            path = directory / name
            if not safe_path(path, self.home):
                raise ValueError("Cannot migrate an unsafe legacy configuration path")
            path.unlink(missing_ok=True)

    def migrate_legacy_enrollments(self, state):
        legacy = [entry for entry in state["enrollments"].values() if not entry.get("migration_required") and self.legacy_endpoint(entry)]
        if not legacy:
            return
        for entry in legacy:
            entry["ended_at"] = entry.get("ended_at") or now()
            if state["active"] == entry["enrollment_id"]:
                state["active"] = None
                state["requires_login"] = True
        # Migration cannot leave collection enabled if settings restoration or cleanup fails.
        atomic(self.path, state)
        for entry in legacy:
            self.remove_legacy_proxy_files(entry)
            try:
                self.restore_editor(entry)
                entry.pop("editor_error", None)
            except (ValueError, OSError):
                entry["editor_error"] = "Fix editor settings syntax/permissions, then run course login to use the current endpoint."
            retained = entry.setdefault("redaction_secrets", [])
            expires = (dt.datetime.fromtimestamp(timestamp(entry["enrolled_at"]), dt.timezone.utc) + dt.timedelta(days=30)).isoformat()
            for value in (entry.get("eip_api_key"), entry.get("adapter", {}).get("local_token")):
                if value and not any(secret["value"] == value for secret in retained):
                    retained.append({"value": value, "expires_at": expires})
            for field in ("adapter", "adapter_error", "eip_api_key", "eip_system_name"):
                entry.pop(field, None)
            entry["migration_required"] = True
        atomic(self.path, state)

    def environment(self, enrollment):
        if self.legacy_endpoint(enrollment):
            raise ValueError("Course endpoint changed. Run course login again to receive the current native endpoint.")
        endpoint = enrollment["inference_base_url"].rstrip("/")
        direct = endpoint == "https://api.anthropic.com"
        env = {"ANTHROPIC_AUTH_TOKEN": "" if direct else enrollment["api_key"],
               "ANTHROPIC_API_KEY": enrollment["api_key"] if direct else "", "CLAUDE_CODE_OAUTH_TOKEN": "",
               "ANTHROPIC_BASE_URL": enrollment["inference_base_url"],
               "ANTHROPIC_CUSTOM_HEADERS": "",
               # Picker allowlist is exact Opus 5.5 and Sonnet 5.5; see managed-settings.json.
               # ANTHROPIC_MODEL outranks the settings model key, so the default is set here.
               "ANTHROPIC_MODEL": "global-anthropic.claude-opus-5-5",
               "ANTHROPIC_DEFAULT_OPUS_MODEL": "global-anthropic.claude-opus-5-5",
               "ANTHROPIC_DEFAULT_SONNET_MODEL": "global-anthropic.claude-sonnet-5-5",
               "ANTHROPIC_DEFAULT_HAIKU_MODEL": "global-anthropic.claude-sonnet-5-5",
               "CLAUDE_CODE_SUBAGENT_MODEL": "global-anthropic.claude-sonnet-5-5",
               "CLAUDE_CONFIG_DIR": enrollment["config_dir"],
               "DISABLE_AUTOUPDATER": "1"}
        if endpoint == "https://aah.aihub.a-star.edu.sg":
            env["MAX_THINKING_TOKENS"] = "0"
            env["ENABLE_TOOL_SEARCH"] = "false"
        return env

    def editor_paths(self):
        custom = os.environ.get("VSCODE_AGENT_FOLDER")
        if custom:
            return [Path(custom) / "data/Machine/settings.json"]
        # Codespaces and local Dev Containers use different server folder names.
        return [Path.home() / name / "data/Machine/settings.json" for name in (".vscode-remote", ".vscode-server")]

    def configure(self, enrollment):
        directory = Path(enrollment["config_dir"])
        directory.mkdir(parents=True, exist_ok=True, mode=0o700)
        os.chmod(directory, 0o700)
        command = shlex.join([sys.executable, str(Path(__file__).resolve()), "--workspace", str(self.workspace), "hook"])
        hook = [{"hooks": [{"type": "command", "command": command, "timeout": 10}]}]
        atomic(directory / "settings.json", {"cleanupPeriodDays": 30, "hooks": {event: hook for event in
               ("SessionStart", "SessionEnd", "Stop", "PostToolUse", "PostToolUseFailure", "SubagentStop", "PreCompact")}})
        (directory / "skills").mkdir(exist_ok=True, mode=0o700)
        # Drop the old course-owned link after the slide skill is renamed to slides.
        if (self.workspace / ".claude/skills/slides/SKILL.md").is_file():
            previous = directory / "skills/slide"
            if previous.is_symlink() and previous.readlink() in (
                self.workspace / ".claude/skills/slide", self.workspace / "skills/slide"
            ):
                previous.unlink()
        for skill in (self.workspace / ".claude/skills").iterdir():
            if skill.is_dir() and not skill.is_symlink() and (skill / "SKILL.md").exists():
                destination = directory / "skills" / skill.name
                # Refresh enrollment links created before skills moved into .claude.
                if destination.is_symlink() and destination.readlink() == self.workspace / "skills" / skill.name:
                    destination.unlink()
                if not destination.exists() and not destination.is_symlink():
                    destination.symlink_to(skill, target_is_directory=True)
        patches = []
        for path in self.editor_paths():
            if not safe_path(path, Path.home()):
                raise ValueError("Unsafe editor settings path")
            existing, original_text = read_settings(path)
            env = [{"name": key, "value": value} for key, value in self.environment(enrollment).items()]
            changed = {"claudeCode.environmentVariables": env, "claudeCode.disableLoginPrompt": True,
                       "settingsSync.ignoredSettings": sorted(set(existing.get("settingsSync.ignoredSettings", [])) |
                       {"claudeCode.environmentVariables", "claudeCode.disableLoginPrompt"})}
            patches.append({"path": str(path), "original_text": original_text, "previous": {key: existing.get(key) for key in changed}, "written": changed, "written_full": {**existing, **changed}})
        # Originals and intended values are durable BEFORE either remote settings file changes.
        atomic(self.home / "editor-pending.json", {"enrollment_id": enrollment["enrollment_id"], "patches": patches})
        try:
            for patch in patches:
                atomic(Path(patch["path"]), patch["written_full"])
        except Exception:
            self.restore_editor({"editor_patches": patches})
            (self.home / "editor-pending.json").unlink(missing_ok=True)
            raise
        enrollment["editor_patches"] = patches

    def restore_editor(self, enrollment):
        for patch in enrollment.get("editor_patches", []):
            path = Path(patch["path"])
            if not safe_path(path, Path.home()):
                continue
            current, _ = read_settings(path)
            if current == patch.get("written_full") and patch.get("original_text") is not None:
                atomic(path, patch["original_text"], raw=True)
                continue
            for key, written in patch["written"].items():
                if current.get(key) == written:
                    previous = patch["previous"][key]
                    if previous is None:
                        current.pop(key, None)
                    else:
                        current[key] = previous
            atomic(path, current)
        enrollment.pop("editor_patches", None)

    @staticmethod
    def describe_access(enrollment):
        if enrollment.get("credential_mode") == "shared":
            print(f"Course collection cutoff: {enrollment['expires_at']}.")
        else:
            print(f"Configured access expiry: {enrollment['expires_at']}.")
            allowance = enrollment.get("allowance_usd")
            if allowance is not None:
                print(f"Imported participant allowance: USD {allowance} (metadata may be stale).")

    def login(self, if_needed=False):
        with self.state() as state:
            old = state["enrollments"].get(state["active"])
            if if_needed and self.active(old):
                print("Course access configured. Start a new Claude chat; use course status for details.")
                self.describe_access(old)
                return
        if not sys.stdin.isatty():
            print("Run course login in an interactive terminal to receive your course key.")
            return
        print(NOTICE)
        email = input("Approved email (Enter to skip): ").strip()
        if not email:
            print("Skipped. No course collection was enabled.")
            return
        for path in self.editor_paths():
            read_settings(path)
        password = input("Course Password: ")
        with self.state() as state:
            installation_id = state["installation_id"]
        response = self.request("/api/enroll", {"event_id": self.config["event_id"], "email": email,
            "course_password": password, "installation_id": installation_id,
            "notice_version": self.config["notice_version"]})
        with self.state() as state:
            self.accept_enrollment(state, response)
        password = None
        self.start()
        print("Course access configured. Reload the VS Code window, then start a NEW Claude conversation. Terminal: claude")
        self.describe_access(response)

    def accept_enrollment(self, state, response):
        for field in ("enrollment_id", "lease_id", "api_key", "inference_base_url", "models", "expires_at", "upload_token", "upload_expires_at"):
            if not response.get(field):
                raise ValueError("Incomplete keyserver enrollment response")
        if not ID.fullmatch(response["enrollment_id"]):
            raise ValueError("Invalid enrollment identifier")
        base = urllib.parse.urlsplit(response["inference_base_url"])
        if base.scheme != "https" or not base.hostname or base.username or base.password:
            raise ValueError("Inference endpoint must use HTTPS")
        if timestamp(response["expires_at"]) <= time.time():
            raise ValueError("The course collection window has ended" if response.get("credential_mode") == "shared"
                             else "The instructor-configured access has expired")
        if not all(isinstance(response["models"].get(k), str) and response["models"][k] for k in ("main", "small")):
            raise ValueError("Keyserver must configure main and small models")
        if self.legacy_endpoint(response):
            raise ValueError("The course server returned a retired EIP endpoint. Ask the instructor to update it, then run course login again.")
        old = state["enrollments"].get(state["active"])
        if old:
            self.collect(old)
            old["ended_at"] = now()
            state["active"] = None
            atomic(self.path, state)  # A later settings failure must not reactivate the old enrollment.
            self.restore_editor(old)
        enrollment = dict(response, enrolled_at=now(), sessions={}, server=self.server,
                          config_dir=str(self.home / response["enrollment_id"] / "claude"))
        retained = {secret["value"]: secret for previous in state["enrollments"].values()
                    for secret in previous.get("redaction_secrets", []) if timestamp(secret["expires_at"]) > time.time()}
        if retained:
            enrollment["redaction_secrets"] = list(retained.values())
        self.configure(enrollment)
        state["enrollments"][response["enrollment_id"]] = enrollment
        state["active"] = response["enrollment_id"]
        state.pop("requires_login", None)

    def register_hook(self, payload):
        with self.state() as state:
            enrollment = state["enrollments"].get(state["active"])
            if not self.active(enrollment):
                return
            sid = payload.get("session_id", "")
            if not ID.fullmatch(sid) or Path(payload.get("cwd", "/")).resolve() != self.workspace:
                return
            path = Path(payload.get("transcript_path", "/"))
            root = Path(enrollment["config_dir"]) / "projects"
            if not safe_path(path, root) or path.name != sid + ".jsonl":
                return
            sessions = enrollment["sessions"]
            if sid not in sessions:
                # Never enroll a resumed/forked unknown history. /clear starts a new session.
                if payload.get("hook_event_name") != "SessionStart" or payload.get("source") not in {"startup", "clear"}:
                    return
                sessions[sid] = {"path": str(path), "started_at": now(), "files": {}, "sequence": 0, "registered": False}
            self.collect(enrollment)

    def redact(self, text, enrollment):
        values = [enrollment.get("api_key"), enrollment.get("upload_token")]
        values.extend(secret["value"] for secret in enrollment.get("redaction_secrets", [])
                      if timestamp(secret["expires_at"]) > time.time())
        for value in values:
            if value:
                text = text.replace(value, "[REDACTED_COURSE_SECRET]")
                text = text.replace(json.dumps(value)[1:-1], "[REDACTED_COURSE_SECRET]")
        # Common credential assignments and token formats; never upload environment snapshots.
        text = re.sub(r"\bsk-(?:ant-)?[A-Za-z0-9_-]{12,}", "[REDACTED_API_KEY]", text)
        text = re.sub(r"\b(?:ghp_|github_pat_)[A-Za-z0-9_]{12,}", "[REDACTED_GITHUB_TOKEN]", text)
        text = re.sub(r"\bAKIA[A-Z0-9]{16}\b", "[REDACTED_AWS_KEY]", text)
        text = re.sub(r"(?i)((?:[A-Z0-9_]*(?:API_KEY|SECRET_ACCESS_KEY|PASSWORD|AUTH_TOKEN|ACCESS_TOKEN|GITHUB_TOKEN))\s*=\s*)[^\s\\\"]+", r"\1[REDACTED_CREDENTIAL]", text)
        text = re.sub(r"(?i)(Authorization:\s*Bearer\s+)[A-Za-z0-9_.~-]+", r"\1[REDACTED_CREDENTIAL]", text)
        text = re.sub(r"(?i)(X-API-Key:\s*)[^\s\\\"']+", r"\1[REDACTED_CREDENTIAL]", text)
        return text

    def sanitize_record(self, value, session):
        """Remove recognizable credential/environment tool payloads before serialization."""
        sensitive = session.setdefault("sensitive_tools", [])
        if isinstance(value, list):
            return [self.sanitize_record(item, session) for item in value]
        if not isinstance(value, dict):
            return value
        if value.get("type") == "tool_use":
            tool_input = json.dumps(value.get("input", {}))
            command = value.get("input", {}).get("command", "") if isinstance(value.get("input"), dict) else ""
            if (re.search(r"(?:^|[;&|\n])\s*(?:env|printenv|set|export)(?:\s|$)", command)
                    or any(marker in tool_input for marker in (".credentials.json", ".claude.json", "os.environ", "process.env"))):
                if value.get("id") not in sensitive:
                    sensitive.append(value.get("id"))
                return {**value, "input": {"course_redaction": "credential_or_environment_access"}}
        if value.get("type") == "tool_result" and value.get("tool_use_id") in sensitive:
            return {**value, "content": "[REDACTED_SENSITIVE_TOOL_OUTPUT]"}
        return {key: ("[REDACTED_ENVIRONMENT]" if key in {"env", "environment", "environmentVariables"}
                      else "[REDACTED_CREDENTIAL]" if re.search(r"(?i)(?:api[_-]?key|secret(?:[_-]?access[_-]?key)?|password|authorization|credential|access[_-]?token|auth[_-]?token|github[_-]?token)$", key)
                      else self.sanitize_record(item, session)) for key, item in value.items()}

    def queue(self, enrollment, sid, source, content):
        session = enrollment["sessions"][sid]
        content = self.redact(content, enrollment)
        chunk = {"session_id": sid, "chunk_id": str(uuid.uuid4()), "sequence": session["sequence"],
                 "source": source, "captured_at": now(), "content": content,
                 "sha256": hashlib.sha256(content.encode()).hexdigest()}
        # Pending payloads, file offsets and sequence counters share one atomic state commit.
        # A crash before commit recaptures the source; a crash after server receipt retries the SAME chunk.
        enrollment.setdefault("pending", {})[chunk["chunk_id"]] = chunk
        session["sequence"] += 1

    def capture_file(self, enrollment, sid, path, source, jsonl=True):
        session = enrollment["sessions"][sid]
        root = Path(enrollment["config_dir"]) / "projects"
        if not safe_path(path, root) or not path.is_file():
            return
        relative = str(path.relative_to(root))
        with path.open("rb") as handle:
            stat = os.fstat(handle.fileno())
            previous = session["files"].get(relative, {"offset": 0, "generation": 0})
            offset = previous["offset"]
            generation = previous["generation"]
            # Detect replacement/truncation or in-place prefix rewriting (compaction).
            prefix = handle.read(min(offset, 4096))
            if (stat.st_size < offset or (previous.get("inode") and previous["inode"] != stat.st_ino)
                    or (previous.get("prefix") and hashlib.sha256(prefix).hexdigest() != previous["prefix"])):
                offset, generation = 0, generation + 1
            handle.seek(offset)
            raw = handle.read(MAX_CHUNK)
            if not raw:
                return
            if jsonl:
                end = raw.rfind(b"\n") + 1
                if not end:
                    if len(raw) == MAX_CHUNK:
                        # Oversized record is represented explicitly, never silently lost or retried forever.
                        skipped = len(raw)
                        while raw and not raw.endswith(b"\n"):
                            raw = handle.readline(MAX_CHUNK)
                            skipped += len(raw)
                        if not raw or not raw.endswith(b"\n"):
                            return  # Even oversized partial records wait for their terminating newline.
                        record = {"course_capture_gap": "record_exceeds_512KiB", "file": relative, "bytes": skipped,
                                  "generation": generation, "offset": offset}
                        self.queue(enrollment, sid, source, json.dumps(record) + "\n")
                        offset += skipped
                    else:
                        return  # Incomplete JSONL remains for the next pass.
                else:
                    raw = raw[:end]
                    lines = []
                    for line in raw.decode("utf-8", errors="replace").splitlines():
                        try:
                            obj = self.sanitize_record(json.loads(line), session)
                        except ValueError:
                            obj = {"course_capture_gap": "invalid_jsonl", "file": relative}
                        # Discover references from sanitized records incrementally, including subagents.
                        results_root = str(Path(session["path"]).parent / sid / "tool-results") + "/"
                        references = session.setdefault("tool_refs", [])
                        for reference in re.findall(re.escape(results_root) + r'[^"\\\s<>]+', json.dumps(obj, ensure_ascii=False)):
                            if reference not in references:
                                references.append(reference)
                        lines.append(json.dumps({"file": relative, "generation": generation, "offset": offset, "record": obj}, ensure_ascii=False))
                    content = "\n".join(lines) + "\n"
                    # Framing may enlarge a chunk: queue record batches below the server bound.
                    batch = ""
                    for line in content.splitlines(keepends=True):
                        if len((batch + line).encode()) > MAX_CHUNK and batch:
                            self.queue(enrollment, sid, source, batch)
                            batch = ""
                        batch += line
                    if batch:
                        self.queue(enrollment, sid, source, batch)
                    offset += len(raw)
            else:
                text = raw.decode("utf-8", errors="replace")
                content = json.dumps({"file": relative, "generation": generation, "offset": offset,
                                      "text": text, "encoding": "utf-8-replace"}, ensure_ascii=False) + "\n"
                self.queue(enrollment, sid, source, content)
                offset += len(raw)
            handle.seek(0)
            prefix = handle.read(min(offset, 4096))
            session["files"][relative] = {"offset": offset, "generation": generation, "inode": stat.st_ino,
                                          "prefix": hashlib.sha256(prefix).hexdigest()}

    def collect(self, enrollment):
        if not self.active(enrollment):
            return
        for sid, session in enrollment["sessions"].items():
            path = Path(session["path"])
            self.capture_file(enrollment, sid, path, "transcript")
            artifacts = path.parent / sid
            if session.get("boundary_path"):
                self.capture_file(enrollment, sid, Path(session["boundary_path"]), "boundary")
            subagents = artifacts / "subagents"
            if safe_path(subagents, Path(enrollment["config_dir"]) / "projects") and subagents.is_dir():
                for item in subagents.glob("*.jsonl"):
                    self.capture_file(enrollment, sid, item, "subagent")
            # Reference discovery follows only newly captured sanitized records, not whole directories.
            results = artifacts / "tool-results"
            for reference in session.get("tool_refs", []):
                item = Path(reference)
                if not safe_path(item, results):
                    continue
                if item.is_file() and item.suffix.lower() in {".txt", ".json", ".jsonl", ".md", ".log"}:
                    self.capture_file(enrollment, sid, item, "tool_result", jsonl=False)
                else:
                    omitted = session.setdefault("omitted_artifacts", [])
                    if reference not in omitted:
                        self.queue(enrollment, sid, "tool_result", json.dumps({"course_capture_gap": "missing_or_nontext_artifact", "file": reference}) + "\n")
                        omitted.append(reference)

    def flush(self, enrollment):
        """Upload a committed snapshot. Network operations never hold the capture lock."""
        if timestamp(enrollment["upload_expires_at"]) <= time.time():
            return
        for chunk in list(enrollment.get("pending", {}).values())[:40]:
            session = enrollment["sessions"][chunk["session_id"]]
            if not session["registered"]:
                self.request("/api/uploads/sessions", {"session_id": chunk["session_id"], "started_at": session["started_at"]}, enrollment)
                session["registered"] = True
                with self.state() as state:
                    state["enrollments"][enrollment["enrollment_id"]]["sessions"][chunk["session_id"]]["registered"] = True
            receipt = self.request("/api/uploads/chunks", chunk, enrollment)
            if receipt.get("durable") is not True or receipt.get("chunk_id") != chunk["chunk_id"] or receipt.get("sha256") != chunk["sha256"]:
                raise ValueError("Upload has no matching durable receipt; retained for retry")
            with self.state() as state:
                pending = state["enrollments"][enrollment["enrollment_id"]].get("pending", {})
                pending.pop(chunk["chunk_id"], None)

    def tick(self):
        had_error = False
        with self.state() as state:
            for enrollment in state["enrollments"].values():
                if enrollment.get("redaction_secrets"):
                    enrollment["redaction_secrets"] = [secret for secret in enrollment["redaction_secrets"]
                                                       if timestamp(secret["expires_at"]) > time.time()]
                self.collect(enrollment)
                if not self.active(enrollment) and enrollment.get("editor_patches"):
                    try:
                        self.restore_editor(enrollment)
                        enrollment.pop("editor_error", None)
                    except (ValueError, OSError):
                        enrollment["editor_error"] = "Fix editor settings syntax/permissions so course settings can be restored."
                        had_error = True
                if time.time() > timestamp(enrollment["enrolled_at"]) + 30 * 86400:
                    shutil.rmtree(self.home / enrollment["enrollment_id"], ignore_errors=True)
                    enrollment["sessions"] = {}
                    enrollment["pending"] = {}
                    for field in ("api_key", "upload_token", "eip_api_key", "eip_system_name", "redaction_secrets"):
                        enrollment.pop(field, None)
        # State and its pending payloads are now durable. Hook registration remains responsive during HTTP.
        for enrollment in state["enrollments"].values():
            error = None
            try:
                self.flush(enrollment)
            except ValueError as exc:
                error = str(exc)
                had_error = True
            with self.state() as latest:
                current = latest["enrollments"][enrollment["enrollment_id"]]
                if error:
                    current["upload_error"] = error
                else:
                    current.pop("upload_error", None)
                    current["last_flush_at"] = now()
        return had_error

    def watch(self):
        with (self.home / "watch.lock").open("a") as lock:
            try:
                fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            except BlockingIOError:
                return
            delay = 0
            while True:
                try:
                    failed = self.tick()
                    delay = min(120, max(15, delay * 2)) if failed else 15
                except (OSError, ValueError):
                    delay = min(120, max(15, delay * 2))
                time.sleep(delay + random.uniform(0, 5))

    def start(self):
        dismiss_pdf_support_prompt()
        with self.state() as state:
            if not state["enrollments"]:
                return
            if state.get("requires_login"):
                print("Course endpoint changed. Run course login again to receive the current native endpoint.")
        subprocess.Popen([sys.executable, str(Path(__file__).resolve()), "--workspace", str(self.workspace), "watch"],
                         stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                         start_new_session=True, close_fds=True)

    def status(self):
        with self.state() as state:
            enrollment = state["enrollments"].get(state["active"])
        if not enrollment:
            print("Not enrolled. Run course login to opt in.")
            return
        print(f"Course access: {'configured' if self.active(enrollment) else 'ended'}; collection {'on' if self.active(enrollment) else 'off'}")
        self.describe_access(enrollment)
        print(f"Queued chunks: {len(enrollment.get('pending', {}))}")
        if enrollment.get("upload_error"):
            print(enrollment["upload_error"])
        try:
            status = self.request("/api/lease", enrollment=enrollment)
            fields = (("credential_mode", "expiry_source", "expires_at", "provider_expires_at")
                      if status.get("credential_mode", enrollment.get("credential_mode")) == "shared"
                      else ("expires_at", "allowance_usd", "usage", "budget_revision"))
            print(json.dumps({k: status[k] for k in fields if k in status}, indent=2))
        except ValueError as exc:
            print(str(exc))


    def logout(self):
        # Consent withdrawal is durable BEFORE optional tail capture, settings recovery or HTTP.
        with self.state(recover_editor=False) as state:
            enrollment = state["enrollments"].get(state["active"])
            if not enrollment:
                return
            enrollment["ended_at"] = now()
            state["active"] = None
        with self.state(recover_editor=False) as state:
            current = state["enrollments"][enrollment["enrollment_id"]]
            try:
                self.restore_editor(current)
                current.pop("editor_error", None)
            except (ValueError, OSError):
                current["editor_error"] = "Editor settings could not be restored; fix settings syntax/permissions and run course start."
                print(current["editor_error"])
        try:
            self.flush(enrollment)
            self.request("/api/logout", {}, enrollment)
        except (ValueError, OSError):
            print("Server unavailable; collection is stopped locally. Queued records will retry until upload expiry.")
        print("Course collection stopped. Close existing Claude chats and reload VS Code. Provider access remains controlled externally.")

    def boundary(self, arguments):
        parser = argparse.ArgumentParser(prog="course boundary")
        parser.add_argument("--session")
        parser.add_argument("--mount", required=True)
        parser.add_argument("--resource", required=True)
        args = parser.parse_args(arguments)
        with self.state() as state:
            enrollment = state["enrollments"].get(state["active"])
            if not self.active(enrollment):
                raise ValueError("Course boundary capture requires active course login and a new Claude session.")
            sessions = enrollment["sessions"]
            sid = args.session
            if not sid and len(sessions) == 1:
                sid = next(iter(sessions))
            if sid not in sessions:
                raise ValueError("Pass --session with the registered Claude session ID when more than one course session is open.")
            transcript = Path(sessions[sid]["path"])
            audit = transcript.parent / sid / "boundary.jsonl"
            if not safe_path(audit, Path(enrollment["config_dir"]) / "projects"):
                raise ValueError("Unsafe boundary audit path")
            audit.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
            sessions[sid]["boundary_path"] = str(audit)
        try:
            subprocess.run(["node", str(self.workspace / ".claude/skills/boundary-test/broker.mjs"), "request",
                            "--mount", args.mount, "--resource", args.resource, "--audit", str(audit)], check=True)
        finally:
            with self.state() as state:
                enrollment = state["enrollments"].get(state["active"])
                if enrollment:
                    self.collect(enrollment)

    def launch(self, arguments):
        binary = "/opt/claude/node_modules/.bin/claude"
        env = os.environ.copy()
        with self.state() as state:
            if state.get("requires_login"):
                raise ValueError("Course endpoint changed. Run course login again to receive the current native endpoint.")
            enrollment = state["enrollments"].get(state["active"])
            if enrollment:
                if not self.active(enrollment):
                    raise ValueError("Course access expired. Ask the instructor and run course login after an offline update.")
                for key in ("ANTHROPIC_API_KEY", "CLAUDE_CODE_OAUTH_TOKEN", "ANTHROPIC_AUTH_TOKEN", "ANTHROPIC_CUSTOM_HEADERS"):
                    env.pop(key, None)
                env.update(self.environment(enrollment))
        os.execve(binary, [binary] + arguments, env)


def dismiss_pdf_support_prompt():
    """The PDF viewer has no setting for its one-time sponsor prompt. Mark that prompt shown."""
    for relative in (".vscode-server/data/User/globalStorage/state.vscdb", ".vscode/User/globalStorage/state.vscdb"):
        path = Path.home() / relative
        try:
            path.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
            connection = sqlite3.connect(path, timeout=1)
        except (OSError, sqlite3.Error):
            continue
        try:
            connection.execute("CREATE TABLE IF NOT EXISTS ItemTable (key TEXT UNIQUE ON CONFLICT REPLACE, value BLOB)")
            row = connection.execute("SELECT value FROM ItemTable WHERE key = ?", ("mathematic.vscode-pdf",)).fetchone()
            state = {}
            if row and row[0]:
                raw = row[0].decode() if isinstance(row[0], bytes) else row[0]
                try:
                    parsed = json.loads(raw)
                except json.JSONDecodeError:
                    parsed = None
                if isinstance(parsed, dict):
                    state = parsed
            if state.get("supportPromptShown") is True:
                continue
            state["supportPromptShown"] = True
            connection.execute(
                "INSERT INTO ItemTable (key, value) VALUES (?, ?) ON CONFLICT(key) DO UPDATE SET value = excluded.value",
                ("mathematic.vscode-pdf", json.dumps(state)),
            )
            connection.commit()
        except sqlite3.Error:
            continue
        finally:
            connection.close()


def dependencies(workspace):
    dismiss_pdf_support_prompt()
    subprocess.run(["npm", "ci", "--include=dev", "--prefix", str(workspace / ".claude/skills/pptx-generator")], check=True)


def smoke(workspace):
    for command in (["node", "--version"], ["python3", "--version"], ["uv", "--version"],
                    ["/opt/claude/node_modules/.bin/claude", "--version"], ["libreoffice", "--version"], ["fc-match", "Open Sans"]):
        subprocess.run(command, check=True)
    with tempfile.TemporaryDirectory(prefix="course-pptx-") as directory:
        skill = workspace / ".claude/skills/pptx-generator"
        common = ["--template", "assets/corporate-template.pptx", "--plan", "examples/valid-generic.json",
                  "--output", directory + "/smoke.pptx"]
        subprocess.run(["node", "--import", "tsx", "scripts/cli.ts", "build"] + common, cwd=skill, check=True)
        subprocess.run(["node", "--import", "tsx", "scripts/cli.ts", "validate"] + common + ["--require-render"], cwd=skill, check=True)


def main():
    os.umask(0o077)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workspace", type=Path, default=Path.cwd())
    parser.add_argument("command", choices=["setup", "dependencies", "smoke", "activate", "login", "logout", "status", "start", "watch", "flush", "hook", "claude", "boundary"])
    parser.add_argument("arguments", nargs=argparse.REMAINDER)
    args = parser.parse_args()
    workspace = args.workspace.resolve()
    try:
        if args.command == "activate":
            print(f"Activated {activate(workspace)} templates.")
        elif args.command == "dependencies":
            dependencies(workspace)
        elif args.command == "smoke":
            smoke(workspace)
        elif args.command == "setup":
            print(f"Activated {activate(workspace)} templates.")
            if not (workspace / ".claude/skills/pptx-generator/node_modules/tsx").exists():
                dependencies(workspace)
            smoke(workspace)
            print("Ready. Run course login, or allow the Course: sign in editor task.")
        else:
            course = Course(workspace)
            if args.command == "login":
                course.login(if_needed="--if-needed" in args.arguments)
            elif args.command == "hook":
                course.register_hook(json.load(sys.stdin))
            elif args.command == "claude":
                course.launch(args.arguments)
            elif args.command == "boundary":
                course.boundary(args.arguments)
            elif args.command == "flush":
                course.tick()
            else:
                getattr(course, args.command)()
    except (ValueError, OSError, subprocess.CalledProcessError) as exc:
        if args.command == "hook":
            # Hooks never fail the student's model request or echo any payload.
            print("Course capture unavailable; run course status.", file=sys.stderr)
            return 0
        print(f"Course: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

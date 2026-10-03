#!/usr/bin/env python3
"""Start the bundled simulator once and wait for its local health endpoint."""
import fcntl
import json
from pathlib import Path
import subprocess
import time
import urllib.error
import urllib.request


def healthy():
    try:
        with urllib.request.urlopen("http://127.0.0.1:8000/healthz", timeout=1) as response:
            body = json.load(response)
            return body.get("status") == "ok" and "engine_revision" in body
    except (OSError, ValueError, urllib.error.URLError):
        return False


def main():
    state = Path.home() / ".local/state/firetruck"
    state.mkdir(parents=True, exist_ok=True)
    log = state / "server.log"
    with (state / "start.lock").open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        if healthy():
            print("Firetruck ready: http://127.0.0.1:8000/ (Codespaces: open port 8000).")
            return 0
        with log.open("a") as output:
            process = subprocess.Popen(
                ["sh", str(Path(__file__).with_name("run")), "serve", "--port", "8000"],
                stdin=subprocess.DEVNULL, stdout=output, stderr=output,
                start_new_session=True,
            )
        deadline = time.monotonic() + 60
        while time.monotonic() < deadline:
            if process.poll() is not None:
                raise RuntimeError(f"Firetruck exited with code {process.returncode}; see {log}.")
            if healthy():
                print("Firetruck ready: http://127.0.0.1:8000/ (Codespaces: open port 8000).")
                return 0
            time.sleep(0.25)
        process.terminate()
        raise RuntimeError(f"Firetruck did not become ready within 60 seconds; see {log}.")


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, RuntimeError) as exc:
        raise SystemExit(str(exc))

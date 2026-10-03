# Optional firetruck exercise

This exercise is for advanced students or those who finish early. Run `/firetruck` in Claude Code and choose a scenario and map from the live catalogue. The skill guides interactive decisions; the browser is a display and MCP controls the simulation. Sonnet is sufficient.

Codespaces installs the game during the image build, starts it on each container start, and forwards port 8000 without opening a browser automatically. Open **Firetruck simulator** in the **Ports** tab with **Open in Browser**. Forwarded Codespaces ports are private by default; keep this one private. `.mcp.json` configures `hadr` at `http://127.0.0.1:8000/mcp`. The container's managed Claude settings approve this named server; `.claude/settings.json` enables it for local use after the usual workspace trust step. See [Claude's project MCP approval documentation](https://code.claude.com/docs/en/mcp#project-server-approvals-and-workspace-trust). Restart Claude if it was already open when the game started.

From the task root on a local machine with Python 3.12+ and uv, run:

```sh
uv sync --frozen --no-dev --project firetruck
python3 firetruck/start.py
```

Open <http://127.0.0.1:8000/> and use `/firetruck` in Claude Code from the same task root. The startup helper is idempotent and keeps the server running after the command returns. Startup logs are in `~/.local/state/firetruck/server.log`; the engine keeps its own run logs outside the repository. To run it in the foreground instead, use `sh firetruck/run serve --port 8000`.

## Bundled engine

The upstream [Firetruck skill](https://ocelliq.com/FIRETRUCK.SKILL.md) and [engine launcher](https://dl.hadr.ocelliq.com/hadr-engine.py) were retrieved on 2026-10-03. The bundled skill adapts their launch and connection steps to this workshop. Gameplay instructions are retained.

The launcher pins `hadr-game-engine` 0.1.0 to [this engine wheel](https://dl.hadr.ocelliq.com/0.1.0-6f6fe2fb3162/hadr_game_engine-0.1.0-py3-none-any.whl), bundled unmodified in `vendor/`. Its SHA-256 is `6f6fe2fb31628e6d0aa045173a46866dec94ede803c6fa65bbd0119a4a57447f`. `pyproject.toml` retains the launcher's dependency pins and uses that local wheel; `uv.lock` pins dependency artifacts. Installation downloads dependencies during the image build. The installed container runs without downloading the engine or resolving dependencies at startup. Maps, scenarios, browser assets, and MCP are included in the wheel.

## Local Docker verification

Build from the task root:

```sh
docker build -f .devcontainer/Dockerfile -t clm-student-firetruck .
docker run --rm --network none -v "$PWD:/workspaces/task:ro" clm-student-firetruck sh -c 'python3 firetruck/start.py && /opt/firetruck/.venv/bin/python firetruck/smoke.py'
```

This verifies offline startup, the display and map assets, a real Streamable HTTP MCP connection, the scenario catalogue, and starting and advancing a test episode. It uses a fresh disposable container, without student credentials or model calls. The upstream engine listens only on container loopback, so `docker -p` alone cannot expose its display. Codespaces and Dev Containers can forward that loopback port through their **Ports** tab. For a local browser session, open this project in a Dev Container and run `python3 firetruck/start.py`, then open forwarded port 8000.

---
name: firetruck
description: Launch the HADR firetruck simulator, connect a coding agent to its local MCP server, and help a student play interactively.
---

# Play the firetruck simulator

Help the student dispatch limited fire trucks through a simulated city. Incoming reports may be late, incomplete, duplicated, contradictory, or false. Explain decisions briefly and help the student learn by playing.

Recommend **Sonnet or Terra**: either is enough for this exercise. **Opus or Sol** are acceptable alternatives. Strongly discourage **Fable or Astra** for this exercise; they are unnecessary for the intended learning experience. These are recommendations, not a model gate: continue with the student's chosen model.

Never invent or emulate simulator state. Get every simulator fact from the running engine's MCP tools or its HTTP endpoints. Base decisions on the public observations available through MCP, treating human reports as evidence rather than certainty. This is interactive play, not a request to build an application or an automated runner.

## Launch and connect

1. Check that `uv` is available and whether the engine is already running:

   ```sh
   uv --version
   curl --fail --silent --show-error http://127.0.0.1:8000/healthz
   ```

   If `uv` is missing, direct the student to https://docs.astral.sh/uv/getting-started/installation/ and resume once it is installed.

2. If the engine is not running, launch it in a persistent terminal or background process and keep it alive for the session:

   ```sh
   python3 firetruck/start.py
   ```

   If your environment cannot keep a server running, ask the student to run this command in their own terminal and leave it open. Recheck `/healthz` once the server is ready. If startup still fails, report the exact error and stop setup.

3. This workshop preconfigures the **hadr** MCP server in the repository's `.mcp.json`, using Streamable HTTP at **http://127.0.0.1:8000/mcp**. The container's managed Claude settings approve this server; local use relies on `.claude/settings.json` after the usual workspace trust step. Do not add a second server or register it in a personal account.

   Reload or restart the client if needed for the tools to become available. Confirm the connection by calling the read-only `list_scenarios` tool. Tool names may carry the client's `hadr` prefix. In Claude Code, the student can also inspect the connection with `/mcp`. If the tools are unavailable, help fix the connection; do not substitute an imagined simulator or play over HTTP.

4. Give the student the browser display: **http://127.0.0.1:8000/** locally, or open **Firetruck simulator** on port **8000** in the Codespaces **Ports** tab using **Open in Browser**. Keep the forwarded port private. The browser is for watching; control the simulator through MCP. The engine and MCP client need to share a machine or network namespace for these loopback URLs to work.

## Choose a scenario

Use the live scenario catalogue. Scenario IDs are `<scenario>@<map>` pairs: present the distinct scenarios in a table with their stage, title, and short catalogue description, then list the available maps separately. Ask the student to choose a scenario and map. Suggest a stage-1 scenario for a first attempt.

Call `status` before starting. If an episode is already running, offer to resume it or start the chosen scenario; `start_episode` replaces a live episode. Once the student chooses to start, call `start_episode` with the catalogue's scenario ID. It returns the frozen tick-0 observation. Do not advance the clock yet.

## Play interactively

- Call `status` each tick. Briefly explain new reports, truck positions, arrivals, and meaningful changes. Keep uncertain or conflicting reports visibly uncertain.
- Initially propose actions and wait for the student's decision before each `dispatch` and each `next_tick`.
- Convert building IDs learned from contacts with `building_to_coords`; use `travel_time` to compare routes. Read the connected tools' schemas for the required arguments rather than guessing coordinates or vehicle IDs.
- `dispatch` queues a command; it does not advance time. Supply the current `expected_tick`, a vehicle ID, destination, an incident ID you maintain for the suspected fire, and a brief rationale. Commands take effect on `next_tick`.
- Advance exactly one tick with `next_tick(expected_tick = current_tick)`. Always omit its optional `tokens` field: interactive play has no measured token total to report. Never estimate one.
- Once the student gives a policy, such as "send the nearest free truck," explain once that you can follow it autonomously. Continue within that policy and report each tick briefly. Return to the student when a surprise, contradiction, or decision falls outside the policy.
- During a quiet tick, offer to keep advancing until something interesting happens ("NetHack rules"). If accepted, pause for new contacts, arrivals, meaningful state changes, or the end of the episode. Do not skip decisions without the student's agreement.

Each student should use their own engine. The newest MCP session takes control. If control is lost, reconnect and read `status` before taking another action. If `status` unexpectedly returns to the lobby or the run ID changes, report that the engine restarted or the episode was replaced, and agree whether to resume or restart. On `TICK_MISMATCH`, refresh `status` and reconsider the action; never blindly replay an old dispatch or advance.

When the episode is terminal, stop advancing. Summarize the outcomes the engine actually reports, explain one useful lesson from the student's decisions, and offer another scenario or a different policy. Do not invent scores or token use.

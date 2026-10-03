#!/usr/bin/env python3
"""Exercise the real display and MCP in a fresh disposable engine instance."""
import asyncio
import json
import urllib.request

from mcp import ClientSession
from mcp.client.streamable_http import streamable_http_client

BASE = "http://127.0.0.1:8000"


def get(path):
    with urllib.request.urlopen(BASE + path, timeout=10) as response:
        assert response.status == 200, (path, response.status)
        return response.read()


async def main():
    health = json.loads(get("/healthz"))
    assert health["status"] == "ok", health
    assert b"HADR field display" in get("/")
    assert get("/assets/app.js") and get("/assets/app.css")
    async with streamable_http_client(BASE + "/mcp") as (read, write, _):
        async with ClientSession(read, write) as session:
            await session.initialize()
            tools = await session.list_tools()
            expected = {"list_scenarios", "start_episode", "status", "building_to_coords", "travel_time", "dispatch", "next_tick"}
            assert expected <= {tool.name for tool in tools.tools}

            async def call(name, arguments=None):
                result = await session.call_tool(name, arguments or {})
                assert not result.isError, result
                assert result.structuredContent is not None, result
                return result.structuredContent

            catalogue = await call("list_scenarios")
            assert catalogue["scenarios"], catalogue
            status = await call("status")
            assert status["lifecycle"] == "lobby", "Run this check against a fresh disposable engine."
            scenario = catalogue["scenarios"][0]
            episode = await call("start_episode", {"scenario_id": scenario["scenario_id"]})
            assert episode["tick"] == 0, episode
            assert (await call("status"))["tick"] == 0
            assert b"<svg" in get(f"/api/v1/maps/{scenario['map_id']}/display.svg")
            assert json.loads(get(f"/api/v1/maps/{scenario['map_id']}/buildings.json"))["buildings"]
            snapshot = json.loads(get("/api/v1/snapshot"))
            assert snapshot["tick"] == 0, snapshot
            advanced = await call("next_tick", {"expected_tick": 0})
            assert advanced["tick"] == 1, advanced
            assert (await call("status"))["tick"] == 1
            print(f"PASS: engine {health['version']}; display/assets/maps; {len(expected)} MCP tools; "
                  f"{len(catalogue['scenarios'])} scenarios; {scenario['scenario_id']} started and advanced to tick 1.")


if __name__ == "__main__":
    asyncio.run(main())

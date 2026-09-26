# Roblox Rust Starter

Server-authoritative Roblox survival prototype inspired by the supplied six-phase design.

## Stack
- Roblox Studio + Luau
- Rojo for source-controlled project synchronization
- Modular server services
- RemoteEvent boundary with server validation
- GitHub Actions for static validation hooks

## Build phases
1. Core mechanics: building + persistence
2. Resources + inventory
3. Survival + PvP loot
4. Custom inventory/crafting UI
5. Procedural resource spawning
6. Hitscan/raycast rifle

## Development rule
Do not advance a phase until its acceptance tests pass in Studio. Client requests are never trusted for resource ownership, placement legality, damage, or loot transfer.

## Local setup
1. Install Roblox Studio and Rojo.
2. Clone this repository.
3. Run `rojo serve default.project.json`.
4. Connect the place from Roblox Studio to the Rojo server.
5. Run Play Test and execute the phase test checklist in `docs/TEST_PLAN.md`.

## Agent workflow
- **Forge** — implementation agent.
- **Sentinel** — security/server-authority review.
- **Atlas** — integration and Roblox hierarchy review.
- **Vanguard** — test execution and regression review.

Every feature follows: implement -> cross-check -> test -> fix -> approve.

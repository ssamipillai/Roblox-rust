# Roblox Studio Setup

1. Create/open a Baseplate place.
2. Install/start Rojo and run `rojo serve default.project.json`.
3. Connect Studio to the Rojo server.
4. Confirm `ReplicatedStorage/Events`, `Shared`, and `Templates` appear.
5. Confirm `ServerScriptService/Services` and `ServerBootstrap` appear.
6. Enable **Game Settings -> Security -> Enable Studio Access to API Services** only for a test place when testing DataStore persistence.
7. Publish a private test place before persistence testing.
8. Run **Play**. Verify the smoke-test checklist before proceeding to UI polish.

## Important
The supplied design uses `leaderstats` for Wood. This starter keeps that contract for compatibility, while all mutation remains server-side.

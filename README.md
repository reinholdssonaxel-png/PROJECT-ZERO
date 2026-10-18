# PROJECT: ZERO

Roblox Studio / Luau / Rojo prototype: VEX versus AI in HAMNVERKET, eight R15 hero previews and a complete command menu. Desktop FPS gameplay; UI uses scalable layouts and touch-compatible buttons. The canonical roster remains in [PROJECT_SPEC.md](PROJECT_SPEC.md).

## Open and play

Download the raw [ready-built Studio place](releases/PROJECT-ZERO.rbxlx), open it in Studio and press **Play (F5)**. Joining opens the main menu; it does not automatically spawn a combat character.

1. **PLAY → TRAINING → DEPLOY VEX**. The selector allows 30 seconds and defaults to VEX if time expires. Seven unfinished kits are visibly locked for deployment but available to inspect.
2. Spawn inside a safe room for a **15-second preparation**. Movement and combat unlock when the doors open.
3. Use either side exit. Follow yellow circulation lines through the split vestibule and two doglegs. Shortest navigable door-to-contact paths are about **8 seconds** at VEX's walking speed; actual bots take about **12 seconds** through their route landmarks.
4. Fight in the west warehouse, central weighbridge yard or east factory/catwalk. The center pad is a future Control objective; this training mode does not score capture progress.
5. A training round lasts **3 minutes**, then shows results with **RETURN TO MAIN MENU** and **PLAY AGAIN**. M also leaves the current training session for the menu.

## Menu pages and controls

| Item | Behavior |
| --- | --- |
| PLAY | Training selection and server-validated VEX deployment; multiplayer/other modes are visibly Coming Soon |
| HEROES | All eight 3D human R15 models, canonical HP/identity, Idle/Run/Fire/Reload previews |
| ARMORY | Eight corresponding 3D weapon/equipment displays, including paired Atlas gauntlets |
| SETTINGS | Project-wide sound volume, this game's FPS aim sensitivity and local effects/shadow profile; session-only |
| CREDITS | Project identity and used asset authors |
| WASD / mouse / left mouse | Move / aim / fire VX-7 |
| R / Q / Space | Reload / Dash / jump |
| H | Freeze movement/combat server-side and inspect heroes; Back resumes |
| M | Leave the match and return to the main menu |

Main menu/selection/results have no combat character. Inspection anchors the player's root on the server and rejects weapon/Dash requests. Preparation also locks movement and combat. There is no client-authoritative menu bypass.

## HAMNVERKET v2

Each team has two 18-stud doors, separated vestibules, a full-height cross-dock building and workshop gatehouses that force protected turns. Opponents cannot see spawn doors, vestibules or the rear approach corridors from the sampled combat/catwalk positions. Spawn safety is a bounded volume, not the previous blanket `abs(Z) >= 100` check.

West is a connected brick warehouse with alternating fire compartments and side portals; center is a working loading/weighbridge yard with dispatch buildings; east is a factory with machines, a ground flank and a dogleg catwalk. Doors and route metrics are balanced while the two ends use different masonry, cladding and service identities. [Layout and test evidence](docs/HAMNVERKET_V2.md).

Art uses original structural geometry plus the previously reviewed, script-free pipe/container/helmet templates. No new unreviewed Toolbox code was added. Decorative assets never determine collision or cover. [Asset sources and terms](docs/ASSETS.md).

## Build / edit

Use official [Rojo 7 CLI and matching plugin](https://rojo.space/docs/v7/getting-started/installation/). `rokit.toml` pins Rojo 7.7.1.

```powershell
rojo build default.project.json -o releases/PROJECT-ZERO.rbxlx
rojo serve default.project.json
```

Open the built place first, then connect the plugin to localhost:34872 for source changes. Rebuild/reopen after MeshPart-template changes due to [Rojo live-sync limitations](https://rojo.space/docs/v7/sync-details/). All sanitized templates are checked in; manual Toolbox import is unnecessary.

`src/shared`: configuration, spatial contract, R15 factory, fitted armor/weapons, procedural poses and validation. `src/server`: arena, combat, bots, match/session service. `src/client`: first-person controller, HUD and main menu. `assets`: sanitized art templates. `tests`: engine integration suites.

## Verification

In a private Studio play session, deploy VEX and wait for ACTIVE. Use a real server Script so modules share the game's execution context:

```lua
local s = Instance.new("Script")
s.Name = "ZeroVerification"
s.Source = [[
    local ok, result = pcall(function()
        local root = game.ServerStorage.ZeroTests
        local combat = require(root["Combat.spec"]).run()
        local heroes = require(root["Heroes.spec"]).run()
        local map = require(root["Map.spec"]).run()
        local session = require(root["Session.spec"]).run(game.Players:GetPlayers()[1])
        return game.HttpService:JSONEncode({combat=combat, heroes=heroes, map=map, session=session})
    end)
    workspace:SetAttribute("ZeroTestOK", ok)
    workspace:SetAttribute("ZeroTestResult", tostring(result))
]]
s.Parent = game.ServerScriptService
```

The map suite clears/replaces bots; the session suite ends training and returns the test player to MENU. Run only in a private test. [Menu checklist](docs/MAIN_MENU.md), [map evidence](docs/HAMNVERKET_V2.md), [earlier verification](docs/VERIFICATION.md).

Manually check real PLAY/selector buttons, both spawn exits, WASD/aim/fire/reload/Dash, 8-second respawn, all hero/weapon previews, sound/mouse/effects changes, and results-to-menu/replay. GitHub Actions compiles Luau and builds the place; engine tests run in Studio.

## Multiplayer and remaining scope

For local two-client testing, use Studio Server & Clients. Each client begins at MENU and must deploy. Training puts humans on Alpha by default; a developer can set `Workspace.ZeroPvP=true` before Play to alternate human teams. The bot remains Bravo. The public menu's competitive multiplayer option remains locked until that flow is validated.

No published friend session or multi-client session is claimed. Publish a private test under the intended owner, grant playtest access and verify asset permissions before inviting a friend. No experience was published automatically.

Only VEX's primary weapon, Dash, regeneration and respawn are playable. The other seven kits, VEX grenade/ultimate, production animation clips, Control/Escort scoring, mobile combat input, persistence and competitive anti-cheat remain future work. [Per-hero readiness](docs/HEROES.md). Settings deliberately do not change Roblox's account-wide/device rendering preferences.
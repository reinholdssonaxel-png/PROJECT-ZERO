# PROJECT: ZERO

Roblox/Luau prototype: **playable VEX vs one VEX AI opponent**, a detailed HAMNVERKET harbor prototype and **eight distinct R15 hero previews**. Desktop keyboard and mouse. The canonical roster and longer-term game design remain in [PROJECT_SPEC.md](PROJECT_SPEC.md).

## Play in Roblox Studio

A ready-built snapshot is included at [releases/PROJECT-ZERO.rbxlx](releases/PROJECT-ZERO.rbxlx). Download the raw file, open it in Roblox Studio and press Play. All source, sanitized art templates and documentation are also included in this repository; rebuilding from source is recommended after later code changes.

Install the official [Rojo 7 CLI and matching Studio plugin](https://rojo.space/docs/v7/getting-started/installation/). This repository pins Rojo 7.7.1 in `rokit.toml`; `rokit install` installs the pinned CLI if you use Rokit.

```powershell
rojo build default.project.json -o PROJECT-ZERO.rbxlx
```

Open that place in Studio and press **Play** (F5), not Run. The server creates the arena and original R15 VEX rigs at runtime. Wait for the **15-second preparation** and automatic doors, then leave the blue Alpha room. The orange Bravo bot exits its opposite room and seeks you. The spawn rooms are safe zones; neither side can shoot from them or damage someone inside them.

For source editing, run `rojo serve default.project.json`, open a dedicated development place and connect the Rojo 7 plugin to localhost:34872. Rojo maps `ZeroShared`, `ZeroServer`, `ZeroClient` and `ZeroTests`. The map builds when playing; an edit-time preview created during MCP development is optional and is rebuilt on Play. See the official [Rojo build/sync instructions](https://rojo.space/docs/v7/getting-started/new-game/).

Art templates also map to `ReplicatedStorage.ZeroAssets` and `ServerStorage.ZeroArt`. When a MeshPart asset is added/changed, build and reopen the place: Roblox restricts live updates to MeshId. The checked-in sanitized `.model.json` files reproduce the imports; no manual Toolbox import is required. See [Rojo sync limitations](https://rojo.space/docs/v7/sync-details/).

| Control | Action |
| --- | --- |
| WASD / mouse | Move / aim |
| Left mouse, hold | Fire VX-7 |
| R | Reload |
| Q | Dash in movement direction (forward when stationary) |
| Space | Jump |
| Tab | Roblox player list with kills/deaths |
| H | Armory: preview all eight heroes and Idle/Run/Fire/Reload poses; return to VEX |

## Implemented

- VEX: 275 HP; first person; original placeholder armor, orange visor, arms and VX-7; procedural movement, recoil and reload pose.
- VX-7: server raycasts, 13 body damage, **1.5× prototype headshots**, 9 rounds/sec maximum, 36-round magazine, 1.8-second reload, 650-stud range. Tracers, impact flash, hit/kill marker and free Creator Store shot sound.
- Server-owned Dash: **18 / 0.28 = 64.286 studs/sec**, 0.18 seconds, eight-second cooldown; block sweep against walls.
- 15 HP/sec regeneration after five seconds without taking damage; eight-second respawn; two seconds of respawn protection plus safe spawn rooms.
- One opposing R15 AI: sensing/line of sight, reaction delay, aim spread, PathfindingService, movement, shared weapon/ammo/reload rules, death and respawn.
- HAMNVERKET: three lanes, mirrored spawn rooms, panoramic harbor windows, opening doors, lockers, displays, cargo cover, warehouse blocks, factory catwalk/stairs, crane and ship silhouettes, evening lighting.
- Harbor art pass: Swedish signs, warehouse shutters/windows/roof vents, container door hardware, fences, drains, loading rails, reflective puddles, crane braces/cabins, quay hardware, Norrhamn skyline and reviewed Creator Store pipe/container meshes. Simple collision proxies remain separate from visual decoration.
- All eight canonical heroes have original fitted armor, human heads under masks/helmets, differentiated colors/silhouettes, weapons and shared procedural poses. Armory shows HP, identity and implementation status; only VEX is deployable. See [hero readiness](docs/HEROES.md).

## Architecture and security

`src/shared`: immutable hero/weapon catalogs, shared R15 factory, fitted hero armor/weapons, procedural poses, shot/vector validation and geometry helpers. `src/server`: arena/art, characters/health, combat, bots and match bootstrap. `src/client`: input, camera/viewmodel, HUD and Armory. `assets`: sanitized art-only Creator Store templates. `tests`: Studio server integration assertions.

The client sends **only an action and normalized aim/dash direction**. The server resolves the sender's current character, alive state, phase, ammo, reload, cooldown, fire cadence, faction, safe-zone/protection status, origin, range, wall occlusion and damage. A per-player token bucket also limits malformed requests. Normal Roblox character locomotion uses client physics; this is not a complete movement anti-cheat or lag-compensated competitive shooter.

## Verification checklist

1. Play: spawn as VEX at 275 HP / 36 rounds, first-person arms visible, facing the exit. Confirm 15-second preparation; doors open and stay usable after respawn.
2. Walk each lane, cross through the cargo yard and climb the factory stairs. Q dashes briefly and shows an eight-second cooldown; test against cover and a closed preparation door.
3. Outside spawn, hold fire: ammo decreases; R takes 1.8 seconds; no firing during reload. A body hit removes 13 HP and a headshot 19.5. Cover must stop shots; empty magazines must not deal damage.
4. Let the bot find and hit you. Break line of sight: no regeneration for five seconds, then 15 HP/sec. Die and confirm a fresh 275-HP/36-round character after eight seconds. Kill the bot and confirm its return after eight seconds.
5. For the automated assertions, wait for `TRAINING / LIVE`, switch Studio's Command Bar to **Server**, then run this harness (a server Script is required so tests use the same module context as the game):

```lua
local s = Instance.new("Script")
s.Name = "ZeroVerification"
s.Source = [[
    local ok, result = pcall(function()
        return require(game.ServerStorage.ZeroTests["Combat.spec"]).run()
            + require(game.ServerStorage.ZeroTests["Heroes.spec"]).run()
    end)
    workspace:SetAttribute("ZeroTestOK", ok)
    workspace:SetAttribute("ZeroTestResult", tostring(result))
    print("PROJECT ZERO verification", ok, result)
]]
s.Parent = game.ServerScriptService
```

Check `Workspace.ZeroTestOK == true` and Output. Tests create and clean up isolated combatants. Do not run them on a live published server. Actual results and remaining gaps: [docs/VERIFICATION.md](docs/VERIFICATION.md).

## Two local players / friend test

Use Studio's **Server & Clients** test with two clients. Default training puts humans on Alpha against the one Bravo bot; friendly fire is blocked. For opposing human testing, before starting, set Boolean Workspace attribute **`ZeroPvP` to true**. Humans alternate Alpha/Bravo. The training bot still belongs to Bravo; disable it by setting `BotCount = 0` in Config for a pure two-human test. Respawn keeps each player's team. Both modes use normal Roblox replication and RemoteEvents.

For a friend online, publish a **private/restricted test experience** under the intended owner, configure collaborator/playtest access and supported desktop devices in Creator Dashboard, verify audio permissions in that published universe, then join the same server through Roblox. This prototype has not been published automatically. Publishing is separate from committing the source to GitHub. Local multi-client and remote friend sessions must still be verified.

## Assets, scope and next milestone

See [docs/ASSETS.md](docs/ASSETS.md) for Creator Store searches, imported asset review, attribution and fallback choices. No third-party gameplay scripts or FPS framework are used. The project loads the documented pipe/container/helmet meshes and shot sound; authored armor, weapons, map detail and procedural motion code remain original.

Pulse Grenade, Overdrive, full match-start hero deployment/cinematic, Control scoring, the other seven gameplay kits, 5v5 AI fill, mobile controls, authored animation clips, directional damage UI and final production art/audio are **not implemented**. The central pad marks the future Control point. Armory is a working visual archive rather than an unlock of unimplemented kits. The next milestone is two-client/friend testing and an Animator/Animation Editor pass, then implementing the next hero's server-validated weapon and abilities individually.

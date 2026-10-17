# Verification — 2026-10-17

## Visual / eight-hero milestone

- Official Luau syntax compilation and Rojo place build cover **19 Luau files** plus three sanitized JSON art templates.
- Final combined Studio server suite: **114 assertions** — 28 combat assertions and 86 hero/art assertions. The latter check all eight canonical HP/identities, R15 skeletons, weapon registration, pose calls, Animator presence, absence of embedded scripts, honest playable flags, paired gauntlets, separate pistol grips and art budgets.
- Armory was opened with H and all **eight cards were clicked through actual client input**. Each selection produced the matching named WorldModel rig and canonical HP. All four pose controls were clicked and their states read back. Motor6D target and actual arm transforms were compared in the client and matched.
- TITAN, VEX and ECHO Armory captures and a wide harbor capture were visually inspected. A visor-color arithmetic error found during iteration was corrected before the final verification; the final fresh-session suite passed. Preview replacement now builds the new model before removing the old one.
- Arena audit: **782 instances, 679 BaseParts, 34 MeshParts and 22 lights**. Mesh counts are bounded; decorative objects have no touches/queries/collision, imported meshes use Performance fidelity, and detail has no frame loop. These budgets are not a measured mobile FPS guarantee.
- Raw imports were held in ServerStorage during edit-time audit. All four visual/reference imports contained zero scripts. The saved templates retain only geometry/material nodes, and review staging was removed from Studio after export.
- Single-client gameplay remains VEX vs one bot. Other heroes are explicitly visual prototypes; no unimplemented kit can be deployed from Armory. The previous multiplayer/publication gaps below still apply.

## First playable evidence

Target: connected Roblox Studio **Place1**, single-client Play mode, VEX vs one Bravo bot. Source was synchronized into the same service layout as `default.project.json` through Studio MCP. The final arena preview contains 213 instances. Rojo 7.7.1 builds the same source into a standalone place; arena construction occurs on Play.

## Passed

- **Offline syntax:** every one of the 11 Luau files compiled using official Luau 0.743 `luau-compile --null`.
- **Rojo:** `rojo build default.project.json -o build/PROJECT-ZERO.rbxlx` succeeded. `rojo sourcemap` also succeeded. `git diff --check` passed.
- **Studio initialization:** server initialized preparation/active phases, doors opened, player used a controllable R15 VEX with 275 HP, 36 rounds, `LockFirstPerson`, a Humanoid camera subject, separate arms/rifle and live HUD. Initial spawn orientation was corrected and checked in a fresh Play session.
- **Navigation and incoming fire:** bot traveled from Bravo spawn (`z=121`) to the Alpha-side lane (`z≈-54`), acquired the human after leaving the safe room, fired and killed the player. The open center route was observed; every flank and stuck-path case has not been exhaustively tested.
- **Actual client firing:** after aim/input through MCP, server ammo changed **36 → 29** and bot health **275 → 151.5**. Body/head hit mix reflects recoil. Temporary player protection and an anchored bot were used for this controlled shooting observation, then removed by restarting Play.
- **Client reload/Dash:** R restored ammo **29 → 36** with server `ReloadEnd=0` after completion. Q displaced the player from approximately `z=-82` to `z=-72.85`, set the server cooldown and updated its HUD countdown.
- **Remote input rejection:** actual client RemoteEvent requests containing zero, NaN, infinite, oversized, table and string directions left server ammo at **36** and bot health at **275**.
- **Final server integration suite:** **28 assertions passed**, in a real server Script context, with `Workspace.ZeroTestOK=true` and `ZeroTestResult="28"`. Covers invalid vectors, body/head damage, fire rate, authoritative ammo, friendly fire, occlusion, range, spawn restrictions/protection, reload timing and exclusions, empty magazine, regeneration delay/rate, Dash cooldown/force cleanup and dead shooters.
- **Respawn:** measured player CharacterAdded **8.002 seconds** after death, new character **275 HP / 36 rounds**. A bot killed alongside the player was replaced by a distinct living 275-HP bot at the 8.2-second check.
- **Audio/visual inspection:** Creator Store shot sound reported `IsLoaded=true` in the Studio client; shot playback was invoked during firing. First-person weapon/HUD and the industrial night scene were inspected using Studio captures. Perceived audio quality, balance and spatial mix still require a human listening pass.
- **Final runtime log:** no error messages containing the project's `Zero` name were found after the final Play test. Roblox Core UI emitted unrelated FoundationProvider warnings earlier; those are not evidence of game feature failures.

During testing, one harness was invoked before preparation finished; its explicit phase assertion stopped it. Rerunning after ACTIVE passed. Calling combat modules directly through the MCP command environment also proved to use a different module context from normal game Scripts, so the documented harness creates a real server Script.

## Remaining checks and limitations

- No two-client Studio multiplayer session or remote friend session was run. Roblox server replication is implemented; multi-client visibility, competing hits and team rules still need the README checklist.
- No experience was published. Published-universe sound permissions, device settings, access permissions and real network latency remain unverified.
- The Rojo build and source map were verified locally. The Studio session was synchronized via MCP, rather than by clicking a Rojo plugin connection; interactive plugin live sync has not been exercised here.
- GitHub Actions validates syntax and builds the place; it does not run Roblox engine integration tests. The latter must run in Studio with the documented harness.
- Art is a functional blockout; authored Animator clips, final meshes/audio, mobile input and competitive movement anti-cheat are deferred. No final 5v5, hero selection, Control mode, grenade or ultimate is claimed.
- Spawn-room layout, all three lanes, catwalk stairs and wall-aware Dash exist; full traversal/lighting/performance evaluation across devices is still a manual follow-up.

## Reproduce

Build/open with Rojo, Play, wait for ACTIVE, run the README's server-Script test harness and carry out its manual control/bot/multiplayer checklist. Stop Play after tests; the test-created dummies and temporary test Scripts are runtime-only and are not saved into the Rojo build.

# Main menu and session flow — 2026-10-18

## Implemented

Joining opens a dark blue-gray command menu with an oversized PROJECT: ZERO title, orange accents, tweened hover/fade transitions and an original industrial 3D stage. VEX is a real articulated R15 WorldModel with a breathing/idle pose and orange visor; models and weapons reuse the existing factory/catalog/pose systems.

- **PLAY:** actual training-mode selection; competitive multiplayer and other modes are visibly locked/Coming Soon.
- **HEROES:** all eight canonical human R15 operatives, HP/identity/readiness and four pose controls.
- **ARMORY:** all eight weapons/equipment displays. Atlas has visible paired gauntlets in its standalone preview; Phantom's character holds a pistol in each hand. Camera framing adapts to weapon bounds and viewport aspect.
- **SETTINGS:** session-only ZeroAudio SoundGroup volume, custom FPS-camera aim multiplier (0.2–2.0), and local low/high effects/shadows. This does not pretend to change restricted Roblox account/device rendering settings.
- **CREDITS:** actual project identity and used asset authors, rather than placeholder links.

Layout uses proportional positioning, wrapped/scaled text with size limits, aspect-aware 3D framing, and Activated buttons for mouse/touch. Desktop Studio views were inspected. Separate phone/tablet/device-emulator sessions remain a follow-up; gameplay itself still targets keyboard/mouse.

## Server-owned flow

`MENU → SELECT → PREPARE → ACTIVE → RESULTS → MENU`.

PLAY sends a rate-limited Flow request. Selection has a 30-second deadline and permits only VEX deployment; its timeout also deploys VEX. Invalid/locked hero IDs are rejected server-side. There is no combat character in MENU, SELECT or RESULTS. The first deployment starts 15-second preparation with an anchored root and disabled combat; joining an already active training round does not restart everyone else's timer. The round ends after 180 seconds via the match service and presents results.

H during ACTIVE opens HEROES as **INSPECT**: server movement is anchored and fire/Dash are rejected. Back sends Resume, restoring the session. M explicitly leaves for the main menu. Returning to menu cancels pending deployment for that player; leaving the last participant resets bots and doors. Respawn remains eight seconds and cannot respawn someone who has left the match.

Session state is in server-written `Player.ZeroSession`; combat validates it independently of GUI visibility. Flow has its own token bucket. UI settings are local and cannot grant ammo/damage, bypass hero locks or alter server phase.

## API choices

- Project audio mixer: Roblox SoundGroup.Volume, assigned to menu, rifle, hit and spatial shot sounds.
- Aim: this game's first-person yaw/pitch controller consumes mouse delta and the local ZeroAimSensitivity multiplier. It does not overwrite Roblox's account sensitivity setting.
- Graphics: local Lighting.GlobalShadows and optional muzzle effects; no restricted render-quality APIs.
- No DataStore or persistence claim. Settings survive character respawns/menu transitions within the same client session, and reset on a fresh join.

## Studio tests performed

1. Fresh join: MENU displayed, VEX 3D scene present, no combat character; world phase IDLE.
2. Actual UI clicks opened PLAY, HEROES, ARMORY, SETTINGS and CREDITS. Each of eight hero cards produced its matching R15 model and canonical HP; each of eight armory cards produced visible weapon parts (including Atlas).
3. Actual Settings clicks changed volume **0.7 → 0.6**, aim multiplier **1.0 → 1.1** and LOW effects with `GlobalShadows=false`.
4. PLAY → TRAINING opened SELECT without a character. A forged Deploy(TITAN) request was rejected. Deploy VEX produced PREPARE with an anchored character at `(0,4.6,-230)`.
5. W during preparation/inspection did not move the anchored player. Inspect also rejected authoritative shooting and Dash. Back restored ACTIVE.
6. Actual ACTIVE input moved through a door; firing changed server ammo **36 → 29** and target HP **275 → 216.5** in a controlled aim test. Reload restored the magazine; Dash moved the character/set cooldown.
7. Ending via the real match service displayed RESULTS with score fields and removed the combat character. Actual RETURN TO MAIN MENU input displayed HOME again. PLAY/deployment could be repeated.
8. `tests/Session.spec.luau`: **14 assertions passed**, covering server locks, transitions, invalid deployment, preparation and leaving/reset. Existing combat/hero tests passed 114 assertions, and Map.spec passed 1,723.

The results path was exercised both by the controlled finishRound service call and by a later natural 180-second training timeout: the observed state became RESULTS with no combat character. This is not a competitive multiplayer match test. Multi-client synchronization, published friend play and persistent settings are not yet validated.

## Manual checklist

On a fresh Play session, verify all five nav buttons, hover behavior, all eight hero/weapon previews, pose buttons and locked deployment styling. Adjust each setting at its limits. Deploy VEX, attempt shooting/movement in preparation, then verify movement/aim/fire/reload/Dash after doors open. H must freeze controls and Back must restore them. Leave with M; the player must not respawn behind the menu. Play again and let the natural timer finish; check results, return and replay. Repeat at narrow/wide viewport sizes and in Studio Server & Clients before publishing.

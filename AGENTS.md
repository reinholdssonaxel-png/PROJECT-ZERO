# PROJECT: ZERO — Codex agent instructions

You are building PROJECT: ZERO, a Roblox Studio hero-shooter prototype. Read PROJECT_SPEC.md before making design decisions.

## Non-negotiable
- Target **Roblox Studio**, not Unity, Unreal, or a standalone game engine.
- Write **Luau** and maintain a **Rojo-compatible** source layout and `default.project.json`.
- Implement a working, testable game incrementally; do not stop at pseudocode or illustrative snippets.
- Start with VEX, VX-7, first-person controls, server-authoritative shooting, simple HAMNVERKET arena, and AI bots.
- Prioritize reliable gameplay and clear architecture over art polish.
- Preserve the established hero roster and specs in PROJECT_SPEC.md. Do not silently replace heroes, lore, map, or mechanics.
- Avoid unreviewed Toolbox scripts and free-model code. Prefer self-made placeholder geometry and licensed assets whose origins are documented.
- Never trust client-supplied damage, hit positions, cooldowns, ammo counts, or character ownership. Validate remote requests server-side, with rate limits and plausible range/line-of-sight checks.
- Design for Roblox multiplayer from the beginning; use Roblox replication and RemoteEvents. Do not build custom networking servers.
- Keep frame rate and mobile/low-end performance in mind, even if desktop FPS is the initial target.
- Do not claim features have been play-tested in Studio unless actually tested there.

## First milestone
1. Initialize Rojo project with clear `src/server`, `src/client`, `src/shared` layout and README setup steps.
2. Build playable VEX: 275 HP, first-person camera, temporary VX-7 model, raycast firing, 36-round magazine, 1.8 s reload, 13 damage per shot, 9 shots/sec, basic recoil, hit effects, HUD.
3. Add Dash (8-second cooldown; 18 m/s for 0.18 s) and simple health regeneration (15 HP/s after 5 s out of combat).
4. Create a basic, lit evening HAMNVERKET arena with two symmetrical spawn rooms, panoramic windows, and three approach lanes.
5. Add at least one AI opponent with navigation, target acquisition, shooting, death and respawn. Scale up only after one bot works.
6. Support local Studio multiplayer testing; document limitations and next steps for a friend joining via published Roblox experience.
7. Iterate with tests and concise progress reports.

## Working rules
- At the beginning of each task inspect the existing repository; do not overwrite functioning work.
- Make small, understandable commits and keep README and PROJECT_SPEC.md aligned with intentional changes.
- Write a short verification checklist for every milestone and disclose what was not testable outside Studio.
- Ask the user only for decisions blocking implementation. Use reasonable placeholders otherwise.
- Do not import full third-party FPS frameworks blindly; inspect licensing, compatibility (R15), code quality, and security first.

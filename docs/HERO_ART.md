# Fitted mesh hero art — 2026-10-18

## Implementation

`RigFactory` retains a single 15-Motor6D R15 skeleton and the existing server hit volumes/HP. Roblox's native R15 mesh geometry, obtained from `Players:CreateHumanoidModelFromDescriptionAsync` with an empty description, supplies a fitted human undersuit. Hidden body volumes retain combat behavior; visible undersuit clones contain geometry only, never copied joints. The head remains human under protective gear.

`MeshHeroStyle` uses separate hero helmet/cuirass templates, common modular limb shells and individual equipment. TITAN is broad and heavy; ATLAS has exposed hydraulics and powered hands; VEX has a tactical carrier/respirator; PHANTOM has a narrow silhouette and split coat; HAVOC has blast protection and grenades; SPECTRE has a fabric hood/green optics; NOVA has white medical armor/cylinders; ECHO has tech plates/projection equipment. These are adapted development meshes, not a claim of finished production character art.

`ArmorFit` mounts every rigid component to exactly one named body limb with a WeldConstraint. Cosmetics are massless, unanchored, noncollidable, nontouchable and nonqueryable. They cannot widen hitboxes or prevent movement. No armor bridges elbows/knees. SpecialMesh scale is fitted explicitly. Render/collision fidelity is baked into templates because Roblox restricts runtime writes to those properties.

The shared weapon factory uses the same reviewed geometry in ARMORY, held third-person weapons and VEX's separate first-person model. Phantom mounts one pistol to each hand; Atlas's gauntlets mount to both hands. A simple invisible muzzle marker supports existing effects. Authoritative damage/ammo/reload/Dash remain unchanged.

Motion uses anatomical shoulder/elbow/hip/knee pivots and a persistent `ZeroBindC0` attribute. This avoids cumulative pose drift when weak Lua Instance wrappers are collected. Current Idle/Run/Fire/Reload motions are procedural; every rig still includes an Animator. Published Animation Editor clips, finger posing, cloth skinning and a final grip/animation polish pass are not claimed.

## Asset review

The user's live Studio models were inspected recursively, including duplicate `hats` models. No LuaSourceContainers were present. Their geometry is preserved unchanged in `ServerStorage.ZeroAssetReview.UserProvided`, keeping loose prefab collisions out of the arena. Metadata and integration decisions are recorded in ASSETS.md. The GitHub build excludes those original franchise models; inspection does not grant their third-party rights.

Roblox AI kit generation sometimes returned both arms/legs in one mesh, duplicate torsos or an incorrect tiny segment. Those pieces were rejected. Only individually usable shells are retained. Common limb guards and ECHO's replacement helmet were generated individually, inspected and fitted. VEX's generated chest looked like a backpack and was replaced with a reviewed Creator Store carrier. Source generated models are preserved in Studio's `ServerStorage.ZeroAssetReview.GeneratedSources`; checked-in templates retain AI provenance attributes and mesh/texture IDs. No generated runtime AI calls are needed to play.

## Test checklist

The final Studio regression passed **6,603 assertions**: 4,216 moving-armor, 622 hero/art, 28 combat, 1,723 map and 14 session. Moving-armor checks exercised all eight heroes through Idle/Run/Fire/Reload and repeated pose changes. Maximum observed mount translation error was **0.0000651 studs**; no gear detached or accumulated pose drift. Each hero retained **15 motors**, **48–54 BaseParts**, and **38–40 MeshParts** including invisible hit volumes. Fourteen invisible original body meshes are excluded from visible geometry, so those instance counts are not draw-call counts.

The rebuilt warehouse retained all **1,680 blocked spawn sightline rays**. Both teams' two exit paths remained equal: **178.24 / 175.28 studs**, about **8.10 / 7.97 seconds** at walking speed. Existing combat/session assertions passed with the new VEX model. All **26 Luau files** compiled with official Luau 0.743 and Rojo 7.7.1 built the place successfully; `git diff --check` passed.

Fresh-session actual input after the final client-attach fix: PLAY/TRAINING/DEPLOY opened preparation and then ACTIVE; the first-person model contained the rifle and two mesh sleeves. In a controlled outside-spawn aim test, W moved the player from z=-80 to -70.14, left mouse consumed ammo **36 → 28**, and the registered AI target took **275 → 171 HP** (eight body hits). Reload restored 36, Q set Dash cooldown/moved the player and M returned to HOME without a character. Temporary target anchoring/player protection were test-only and removed by stopping Play. Published/device/authoring-animation limits below still apply.

Actual HEROES UI input selected all eight models and Run/Fire/Reload controls; actual ARMORY input loaded every weapon, with two meshes for Atlas/Phantom and one for each other weapon. LEFT/RIGHT and zoom input updated inspection yaw to 0.4 and zoom to 0.85; RESET restores the defaults. The long-lived VEX idle kept shoulder pitch 1.05, elbow pitch 0.25 and a nearly horizontal weapon direction after the bind-pose correction. Visual review used Studio captures of VEX, TITAN, PHANTOM, SPECTRE, NOVA and ECHO. This remains a development-art quality pass with procedural animation, not final production animation or character art.

1. Fresh Play must open HOME with VEX, idle motion, orange visor and no combat character. Inspect the full model from HEROES with LEFT/RIGHT, zoom and RESET.
2. Select every hero and inspect Idle/Run/Fire/Reload from front/side/back. Inspect every ARMORY weapon; Phantom must have two pistols, Atlas two gauntlets.
3. Run Heroes.spec in a real server Script. Check 15 motors, canonical HP/status, no embedded scripts, part budget and every armor mount's limb/physics flags.
4. Deploy VEX through PLAY/TRAINING. Preparation must block movement/fire. Check walking, aiming, shooting, reload/Dash, first-person sleeves and rifle, then H inspection and M return.
5. Run existing Combat, Map and Session suites. Map tests must still cover both teams, 1,680 physical spawn sightline rays and all lanes/exits.
6. In a published private test, verify all generated mesh/texture and audio permissions under the intended experience owner. If moving to a group, grant asset access or reimport/upload under that group. Rebuild/open the place after template changes; live Rojo cannot reliably change MeshId.

Device/GPU budgets, mobile clipping, multi-client replication and published-universe permissions require separate hardware/published tests. Part counts and generator triangle ceilings are documented rather than presented as measured GPU performance.

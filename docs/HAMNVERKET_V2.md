# HAMNVERKET v2 — 2026-10-18

The old 184 × 290-stud container grid exposed both spawn doors to a straight center lane. This revision changes the circulation and real occluding architecture before adding visual detail.

Mesh-art follow-up: repeated sawtooth roofs, northlight glazing and mullions give the west warehouse a coherent industrial roof profile. These visual additions do not alter cover/collision. The subsequent engine regression retained 1,680 blocked spawn rays and equal 178.24/175.28-stud exit routes for both teams. Hero mesh equipment remains nonqueryable and cannot invalidate physical cover tests.

## Spatial design

- Quay: **320 × 520 studs**, approximately 90 × 146 m. Spawn centers: `(0, ±230)`.
- Each substantial room has **two independent 18-stud doors** at `x=±42, z=±212`, a dividing structural frontage, harbor windows and separate vestibules.
- A 152 × 26-stud cross-dock with a 32-stud wall height blocks the first approach. Players turn outward into side service corridors, then inward around workshop gatehouses at `x=±98, z=±123`. There is no straight arena-to-door corridor.
- Bounded spawn protection covers the room/vestibules (`abs(x)<=126`, `184<=abs(z)<=252`, below 32 studs). It is distinct from the physical sightline barriers. The previous global `abs(z)>=100` safety test is removed from combat, HUD and bots.
- Bot deployment follows the same protected route landmarks. Once deployed, bot target acquisition is limited to the actual combat area, `abs(z)<=92`, and it does not chase retreating players back into deployment corridors.

| Lane | Architecture and alternatives |
| --- | --- |
| West / Magasin | Connected brick warehouse, two side portals to the yard and alternating full-height fire compartments. No uninterrupted warehouse shooting tunnel. |
| Center / Lastgård | Dispatch houses, marked loading bays, weighbridge control booths and central objective. Cargo belongs to loading operations rather than a random grid. Routes bend around buildings and approach the objective from multiple angles. |
| East / Fabrik | Machinery island, switchgear, ground-level flank, two stair approaches and a dogleg catwalk around the lift house. |

Team circulation footprints and access widths match. The southern office/cross-dock uses brick and Vanguard harbor-office signage; the northern terminal uses metal cladding and customs/utility identity. Cladding, clerestories and service labels vary without moving competitive cover. The west warehouse and east factory are different functional buildings, with equal access from either team.

## Visual and asset strategy

Existing reviewed Poly Haven/Creator Store pipes are mounted as service installations; shipping-container meshes are cargo aboard the moored ship. Collision and cover come from original simple structural geometry. Windows, coping, shutters, roof ventilation, rails, drains and circulation paint describe the buildings' purpose. No new third-party scripts or unreviewed models were introduced. See ASSETS.md.

Audit of the rebuilt map: **666 instances, 552 BaseParts, 34 MeshParts, 35 lights**. This is fewer instances/parts than the previous art pass (782/679). Lights have shadows disabled, decorative objects do not collide/query/touch, and mesh fidelity remains Performance. These counts are not a measured low-end-device FPS guarantee.

## Actual Studio verification

`tests/Map.spec.luau` passed **1,723 assertions** in the connected Studio server:

- **1,680 geometry-only raycasts** from combat positions at x = -140/-104/-48/0/48/104/140, z = -90/-70/0/70/90 and eye heights 5.5/15.5/24, toward eight door/vestibule/corridor samples per faction. Every ray was occluded with preparation doors already open. Ray filtering includes only the arena, so characters or temporary spawn immunity cannot hide an exposed doorway.
- PathfindingService successfully found both deployment routes for both teams and all three end-to-end lane routes. Each tested 180-stud lane ray was interrupted by actual cover.
- A real bot brain was exercised against unprotected R15 targets in both teams' deployment samples. It acquired no target and spent no ammunition there. Moving both characters to the control area restored valid acquisition and damage.

| Team | Exit | Shortest door-to-contact path | At 22 studs/s |
| --- | --- | ---: | ---: |
| Alpha | West | 178.24 studs | 8.10 s |
| Alpha | East | 175.28 studs | 7.97 s |
| Bravo | West | 178.24 studs | 8.10 s |
| Bravo | East | 175.28 studs | 7.97 s |

A separate live walk test spawned **four actual AI bots**, one per faction/exit, and let the normal heartbeat/pathfinding system move them without teleportation. All reached the combat area with `BotPathStatus=Success`. Door-to-contact times were **12.02/12.05 s for Alpha** and **11.78/11.78 s for Bravo**; spawn-to-contact was about 14.1–14.6 s. Bot waypoint/replanning overhead explains the difference from shortest walking-path estimates. This does not establish the exact moment of a first shot in every human match.

The actual human client walked through an open side door: root z moved **-228 → -203.82** over 1.1 seconds of W input. Inspection and preparation W-input checks left the server-anchored player in place. Existing 28 combat + 86 hero/art assertions also passed.

## Reproduce / limits

Open the latest place, PLAY → TRAINING → DEPLOY VEX, wait for ACTIVE, then run Map.spec through the README's server-Script harness. It resets/replaces bots as part of its controlled test; use a private Studio session. Explore both exits, all cross-links and the factory stairs manually after automated checks.

Test coverage is sampled, not a formal proof against every possible camera position, exploit or coordinated spawn push. Two-client human balance, real network latency and low-end/mobile performance still require play sessions. Spawn rooms remain protected even if an enemy pushes toward their doors; physical architecture is what removes the former direct sightlines.

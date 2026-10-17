# PROJECT: ZERO — Game design specification

## Overview
PROJECT: ZERO is an original Roblox Studio **first-person hero shooter**, planned for **5v5** team play. World year: **2042**. Visual direction: **Hybrid Future** — grounded Scandinavian industrial settings and readable, stylized, masked futuristic human combatants. All heroes are ordinary humans equipped with advanced armor and technology, not robots or superhumans. Palette: slate/steel blue, charcoal, orange, cyan. Optimize for responsive FPS gameplay.

## Prototype scope
Deliver a small playable experience as early as possible. Initial training deathmatch: player VEX versus 1–5 VEX AI bots. Then allow two human players to test online in Roblox. Eventually 5v5 with AI fill and role-based teams. Only VEX needs to be selectable at first; display other heroes as locked previews if a selection screen is implemented. Keep all systems extensible.

## Setting and lore
- **Norrhamn:** fictional Swedish coastal industrial city.
- **ZERO Initiative:** secret research organization developing protective technology. A mysterious incident in Norrhamn caused research to vanish.
- **VANGUARD:** international security force.
- **BLACK VEIL:** network of former agents and mercenaries.
- Heroes have different allegiances in the story, but gameplay teams may mix heroes.

## First map — HAMNVERKET
- Fictional harbor industrial district in Norrhamn.
- Autumn evening, approximately **20:30**. Dark blue sky, damp asphalt, reflections, containers, brick warehouses, gantry cranes, industrial lighting, ship at pier. Maintain enough visibility to identify opponents.
- Target mature map footprint about **160 × 180 meters**; prototype can be smaller.
- Three lanes: **west warehouses**, **center cargo yard**, **east factory/catwalk**, with cover and tactical cross-connections.
- One central control point for Control mode.
- Two **symmetrical, substantial spawn rooms** (Team Alpha and Team Bravo) with equal access to the objective, industrial military aesthetic, lockers, map displays, large automated doors and **panoramic windows overlooking the harbor**. Alpha lighting blue; Bravo lighting warm orange/red.
- Match-start presentation: after hero selection, spawn in room; **15-second preparation countdown**, doors open with a signal; after respawn, exits remain usable.
- Prefer atmosphere (wind, rain, distant ships, cranes) without obscuring important gameplay audio.

## Heroes (canonical roster)
Planned composition per team: **1 Tank, 2 Damage, 2 Support**. Eight heroes:

| Hero | Role | HP | Visual / primary weapon | Identity |
| --- | --- | ---: | --- | --- |
| TITAN | Tank | 700 | Dark-blue heavy armor, narrow blue visor; M-90 heavy cannon, shield and slam | Viktor Holm, Swedish, 42, ex-military engineer |
| ATLAS | Tank | 650 | Industrial orange exosuit, orange visor; mechanical gauntlets, melee and charge | Marcus Cole, British, 36, exoskeleton engineer |
| VEX | Damage | 275 | Black/charcoal tactical armor, orange visor; VX-7 assault rifle | Elias Berg, Swedish, 29, former special operative |
| PHANTOM | Damage | 250 | Black/purple stealth suit and mask; twin pistols, cloak, shadow step, Nightfall ultimate | Yuna Takahashi, Japanese, 27, ex-intelligence operative |
| HAVOC | Damage | 300 | Battered red/black explosive armor; grenade launcher, cluster bomb, rocket jump, Annihilator ultimate | Daniel Reyes, American, 34, explosives expert |
| SPECTRE | Damage | 225 | Hooded sniper with green optical lenses; precision rifle, recon dart, grapple, Deadeye ultimate | Anton Volkov, Ukrainian, 38, sniper |
| NOVA | Support | 250 | White/gray medical armor, cyan visor; energy carbine, healing drone, pulse boost, Revival Field ultimate | Sofia Lind, Swedish, 31, biomedical engineer |
| ECHO | Support | 275 | Futuristic tech armor with holographic shields; pulse carbine, shield pulse, disruptor, Amplify ultimate | Adrian Moreau, French, 33, technology developer |

## VEX: first playable hero
- HP **275**.
- **VX-7** hitscan assault rifle: **13 damage per body hit**, **9 rounds/second**, **36-round magazine**, **1.8-second reload**.
- **Dash**: speed **18 m/s**, duration **0.18 s**, cooldown **8 s**. Convert gameplay units appropriately for Roblox and tune feel through playtesting.
- **Pulse Grenade** ability, parameters to tune in later milestone.
- **Overdrive** ultimate, parameters to tune later.
- First-person viewmodel arms + rifle, basic firing/reload animations, responsive audio and recoil.
- Hero-select intro (later): steps out of shadows, checks VX-7 magazine, orange visor activates, raises rifle, says “Ready for action”; 3–4 s, skippable.

## Combat
- Relatively long target time-to-kill around **2–4 seconds**, subject to balancing.
- Headshots have a damage multiplier; choose and document a prototype value rather than silently assuming final balance.
- Regenerate **15 HP/s after 5 seconds without taking damage**.
- **8-second respawn**.
- Use raycasts for hitscan weapons; validate hit requests, fire rate, ammunition, alive state, team damage rules and range on server. Responsive local effects are permitted but never authoritative.
- Weapon variety is deliberately mixed: conventional ballistic weapons (VEX, PHANTOM, SPECTRE), heavy/explosive (TITAN, HAVOC), mechanical melee (ATLAS), experimental energy (NOVA, ECHO). Each hero should eventually have distinct audio, reload, recoil, and hit effects.
- Build a shared, configurable weapon architecture rather than duplicating code per hero.

## Game modes (longer-term)
- **Training Deathmatch** first: VEX versus AI, then human test.
- **Control**: one capture point, controlled team gains **1% every 1.5 seconds**, first to **100%**, best of three rounds.
- **Escort** and **Frontline** later.
- Character selection occurs **at match start**, not in the main menu. Planned **30-second hero selection** and **15-second preparation**. Hero switching at spawn.
- Eventually 5v5 team composition and AI fill.

## Roblox implementation
- Roblox Studio, Luau, Rojo project structure, R15 hero rigs.
- Roblox Animation Editor / Animator for character animation; separate first-person viewmodel.
- Build basic armor and placeholder helmets in Studio; optionally create more complex custom meshes in Blender later.
- Server-authoritative combat with RemoteEvents; clean module boundaries for weapons, abilities, characters, match state, bots and UI.
- AI bots use PathfindingService and simple sensing/shooting/respawn loops; start with one reliable bot.
- Lighting, Atmosphere and ColorCorrectionEffect for readable industrial evening look.
- Multiplayer runs on Roblox servers; test locally with Studio's multiplayer tools, then publish a restricted test experience for a friend.
- Third-party assets/frameworks must be checked for license, security and R15 compatibility. Prefer custom code and placeholder geometry at first.

## Suggested development order
1. Rojo scaffold + working Roblox place.
2. VEX controller, VX-7, firing/reload/HUD.
3. Dash and basic damage/health/respawn.
4. AI bot and testing arena.
5. HAMNVERKET blockout and spawn rooms.
6. Match flow and hero selection.
7. Multiplayer tests with a friend.
8. Polish, sound, animations, then additional heroes and modes.

## Acceptance criteria for first playable milestone
Player can join in first person as VEX, move, aim, fire VX-7, reload, see health/ammo, hit a target or bot with server-validated damage, use Dash, die and respawn on a basic industrial map. README explains Rojo/Studio setup and exact manual test steps. Do not claim finished features until they are implemented and tested.

## First prototype implementation decisions (2026-10-17)
- Headshots use **1.5× damage** (19.5 HP); body damage remains 13.
- Unit conversion: **1 stud = 0.28 m**; Dash is 64.286 studs/s for 0.18 s with an 8 s cooldown. Weapon range is 650 studs. These are prototype tuning values.
- One Bravo VEX AI opponent; humans join Alpha in training. Optional `Workspace.ZeroPvP` alternates human factions for local opponent testing. This is not the final 5v5 team/match system.
- Compact original Parts blockout, R15 placeholder rigs, procedural gait/reload poses and one documented free Creator Store shot sound. Production meshes and authored Animator clips remain later work.
- Spawn rooms are safe zones and respawns also have two seconds of protection. No damage is dealt from inside a spawn room. The initial 15-second preparation starts when the first player joins.
- Verification evidence and untested multiplayer/publication gaps are tracked in `docs/VERIFICATION.md`; `README.md` documents the exact setup and test steps. All canonical heroes and deferred mechanics above are preserved.

## Visual and roster milestone (2026-10-17)
- HAMNVERKET receives Swedish industrial signage, drainage/loading rails, wet surfaces, warehouse shutters/windows/vents, cargo hardware, fencing, catwalk rails, gantry bracing/cabins, port/city background and reviewed free art templates. Three lanes, the central landmark and two symmetrical safe spawn rooms remain.
- All eight canonical heroes now have distinct original R15 armor/weapon prototypes and Idle/Run/Fire/Reload procedural poses, with canonical identities, roles and HP in `HeroCatalog`. They remain human combatants under fitted protective equipment.
- **H / Armory** previews all eight and reports actual implementation status. VEX remains the only playable kit; the other seven remain visual previews until their server weapon/abilities are implemented and tested. This does not substitute Armory for the later match-start hero-deployment flow.
- Checked-in sanitized art templates contain no scripts. Asset IDs, authors, audit findings, CC0/Creator Store terms and published-permission caveats are in `docs/ASSETS.md`. Per-hero status is in `docs/HEROES.md`.

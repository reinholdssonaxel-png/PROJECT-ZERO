# Hero readiness — visual milestone

All eight models now use fitted mesh equipment on human R15 bodies with a single 15-joint skeleton. Native Roblox body geometry supports distinct helmet/cuirass meshes, role-specific proportions and separately articulated limb shells. VEX adapts a reviewed tactical helmet and plate carrier; other armor uses reviewed Roblox AI meshes plus original equipment. No complete third-party character is used unchanged. [Implementation and checks](HERO_ART.md), [sources/provenance](ASSETS.md).

| Hero | Canonical HP | Visual and weapon model | Gameplay status |
| --- | ---: | --- | --- |
| TITAN | 700 | Broad dark-blue segmented armor, collar, narrow blue visor, cannon cells; four-barrel M-90 heavy cannon | R15/weapon/pose preview; shield/slam/cannon gameplay pending |
| ATLAS | 650 | Orange industrial exosuit, pistons, exo-spine and paired powered gauntlets | R15/gauntlet/pose preview; melee/charge gameplay pending |
| VEX | 275 | Tactical mesh helmet/carrier, respirator and orange visor; mesh VX-7 and first-person armor sleeves | **Playable:** first-person firing, reload, Dash, regeneration, death/respawn and bots. Pulse Grenade and Overdrive pending |
| PHANTOM | 250 | Purple stealth suit, twin optical lenses, mask and split coat; separate left/right suppressed pistols | R15/weapon/pose preview; pistols/cloak/shadow step/Nightfall gameplay pending |
| HAVOC | 300 | Red/black armor, scarred plate, blast pauldron, grenade bandolier; wide-muzzle drum launcher | R15/weapon/pose preview; explosives/rocket jump/Annihilator gameplay pending |
| SPECTRE | 225 | Fabric hood, green optical lenses, recon antenna; long precision rifle with scope | R15/weapon/pose preview; scoped shots/recon/grapple/Deadeye gameplay pending |
| NOVA | 250 | White/gray medical armor, cyan visor, med pack/canisters and medical insignia; energy carbine | R15/weapon/pose preview; healing/drone/pulse boost/Revival Field gameplay pending |
| ECHO | 275 | Blue/gray layered tech armor, projection core and translucent forearm emitters; pulse carbine | R15/weapon/pose preview; pulse/shield/disruptor/Amplify gameplay pending |

Open **HEROES** or **ARMORY** from the main menu, or H during an active session. LEFT/RIGHT rotates the model, +/− zooms and RESET restores the view. Every card shows canonical HP/identity. Pose buttons drive original procedural R15 motions; ARMORY frames standalone weapons/equipment. PLAY permits VEX deployment only. Local WorldModels instantiate one operative/weapon at a time. H inspection freezes movement/combat server-side; Back resumes.

These are stylized development models, not final skinned production art. All have an Animator for a later Animation Editor pass. Current motion is generated through R15 Motor6D poses, not published external animation clips. The two pistol meshes are attached to different hands; Atlas's weapons are fitted directly to both hands.

For a new playable hero, add a server weapon configuration, implement and test that weapon's validated firing/melee/projectile rules, then abilities with server cooldowns, and only then mark `HeroCatalog.Heroes[id].Playable=true` and wire actual deployment. Do not expose the existing VEX server weapon as if it were another hero's finished kit.

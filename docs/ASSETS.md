# Asset sources and review — 2026-10-17

The current milestone combines original fitted hero armor/weapons and procedural poses with reviewed free Creator Store art templates and audio. Searches covered sci-fi rifles/helmets, R15 rigs/armor/animations, industrial containers/pipes and harbor cranes. No paid assets were obtained. No Toolbox gameplay code is included.

2026-10-18 revision: the same audited pipe kits are installed as building services, the container meshes are ship cargo, and original architecture now supplies all gameplay cover. Main-menu scenery is original Parts and existing hero/weapon factories. No additional third-party models or scripts were imported for the layout/menu revision.

## Integrated visual assets

| Asset / source | Audit | Adaptation and checked-in template |
| --- | --- | --- |
| [Modular Industrial Pipes 01, 12308956771](https://create.roblox.com/store/asset/12308956771), Elttob | 7 MeshParts + 7 SurfaceAppearances; **zero scripts** | Four visual pipe kits on warehouse service walls. Anchored, touch/query/collision disabled; Performance render fidelity. `assets/environment/IndustrialPipes.model.json` retains only mesh/material references. Original [Poly Haven source](https://polyhaven.com/a/modular_industrial_pipes_01), Jorge Camacho, **CC0**. |
| [Shipping Container, 11915905277](https://create.roblox.com/store/asset/11915905277), DesiredDestinyx1 | 1 MeshPart; **zero scripts** | Six scaled background cargo props outside the playable collision area. `assets/environment/ShippingContainer.model.json`. Gameplay cover remains original simple geometry with original door/rib/hardware details. Creator Store free listing / Roblox-use terms. |
| [Sci Fi Helmet, 15217448042](https://create.roblox.com/store/asset/15217448042), legitperspective | Accessory with Part/SpecialMesh, attachment and non-script values; **zero scripts** | Export keeps **only** the Part and SpecialMesh. Attachment/configuration/value/touch objects omitted. Base mesh is recolored, texture removed and combined with original armor shell/mask/visor on VEX, TITAN and ECHO. `assets/characters/HelmetReference.model.json`. Creator Store free listing / Roblox-use terms. |

These JSON templates store Roblox mesh/texture IDs and sanitized instance properties, not downloaded mesh/audio binaries. Rojo builds reproduce the templates. Existing mesh IDs cannot always be changed through live sync: rebuild/reopen the place after art-template changes. In Studio MCP the reviewed templates were inserted and placed directly; no further manual asset import is required. Published-experience permission checks still apply, and gameplay continues using the original collision geometry if decorative mesh content is unavailable.

The [R15 Rig reference, 9983145752](https://create.roblox.com/store/asset/9983145752), Paficent, was also imported and inspected: 15 Motor6Ds, 16 body/root parts, attachments, Humanoid, cosmetic/value nodes and **zero scripts**. It informed compatibility inspection; its complete character is not distributed or used unchanged. Original `RigFactory` constructs the base for all eight heroes. This replaces the earlier unimported-shortlist status below.

## Integrated audio

| Asset | Creator / source | Review and integration |
| --- | --- | --- |
| [Assault Rifle Shot, 113879008765178](https://create.roblox.com/store/asset/113879008765178) | circles_squared; Creator Store; listed free | Imported into `ServerStorage.ZeroAssetReview` in edit mode. A `Sound` with SoundId `rbxassetid://113879008765178`; no scripts. `Config.ShotSound` references it for local and spatial gunfire. Studio client reported `IsLoaded = true`; used during firing test. Staging instance removed after inspection. |
| `rbxasset://sounds/button.wav` | Roblox bundled client sound | Temporary hit, reload and match-start feedback. Built-in resource, no downloaded file or scripts. |

Creator Store assets are intended for use in Roblox experiences under the [Creator Store Terms](https://en.help.roblox.com/hc/en-us/articles/21308223046932-Creator-Store-Terms). This is **not** a claim that an asset is CC0, that uploader ownership was independently verified, or that redistribution outside Roblox is licensed. The repository distributes the sound's ID, not a copy of the audio. See Roblox's [audio asset and permissions guidance](https://create.roblox.com/docs/audio/assets) and [asset permissions documentation](https://create.roblox.com/docs/projects/assets/privacy). Recheck permissions and audible playback in the final published universe; an unpublished Studio load does not prove access in every experience. Replace `Config.ShotSound` with an owned/permitted sound if required.

## Reviewed candidate and fallback

[Sci Fi Rifle, 4082840116](https://create.roblox.com/store/asset/4082840116), by Fauxia, was listed free and imported into ServerStorage in **edit mode**, outside active gameplay. Recursive inspection found **one BasePart and zero LuaSourceContainers**. Its staging copy was removed. It is not included in the final runtime or source: the small, configurable original VX-7 matches the first-person rig directly and keeps the prototype reproducible from Rojo source.

`Geometry.rifle()` creates the original VX-7 receiver, barrel, stock, magazine, grip, optic and heat strip. `RigFactory` and `HeroStyle` generate the R15 base and eight fitted costumes; `HeroWeapons` creates each other weapon. `Arena`/`HarborDetail` create the map and layer in the reviewed templates above. The client creates its own first-person arms. Motion and reload poses are original code; every Humanoid includes an Animator for a future authored-animation pass.

## Earlier search shortlist

| Category | Creator Store result | Decision |
| --- | --- | --- |
| R15 | [R15 Rig, 9983145752](https://create.roblox.com/store/asset/9983145752), Paficent | Subsequently imported/reviewed as a compatibility reference, as described above; complete third-party rig is not retained. |
| Animation | [R15 Best walk animation (Blender), 130051797027490](https://create.roblox.com/store/asset/130051797027490), zarubkin | Free listing; defer permission/clip review. Use original procedural gait/reload pose now. |
| Industry | [Industrial Container, 480707484](https://create.roblox.com/store/asset/480707484), Redrockx | Free listing; original ribbed cargo blocks are sufficient for cover and simpler to reproduce. |
| Rifle | [sci-fi rifle, 17764194757](https://create.roblox.com/store/asset/17764194757), roblox_user_2382599860 | Free listing; unimported alternate. |
| Audio | [Sniper rifle shot, 130570662564570](https://create.roblox.com/store/asset/130570662564570), Shibe_exe14 | Rejected: listing explicitly says uploader does not own it. |

Search filters requested verified creators where available; returned names alone are not proof of a verified badge or licensing provenance. No source was treated as Roblox-authored simply because its display name resembled Roblox.

## Future imports

Import selected free/owned models into a quarantine Folder in **ServerStorage in edit mode**. Inspect every Script, LocalScript, ModuleScript, package link and external dependency before enabling anything. For art-only models, retain only needed geometry after review and document IDs/creators/permissions here. Do not rely on an inserted package's sandbox as a substitute for source review. For authored animation clips, publish under the game's intended owner or grant the experience permission, and verify on R15 in a published test. No manual import is needed to play this prototype.

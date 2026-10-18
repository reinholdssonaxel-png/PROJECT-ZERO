# Asset sources and review — updated 2026-10-18

## Current mesh hero revision

All new runtime templates contain geometry/material references and provenance metadata only: **zero Scripts, LocalScripts or ModuleScripts**. No paid assets were purchased. `HeroArt.model.json`, `WeaponArt.model.json` and `HumanBody.model.json` reproduce the equipment with Rojo. Older source/audit history below remains for attribution; the old Sci Fi Helmet is now a fallback asset, not the main mesh costume.

### New free Creator Store assets used

| Source | Inspection and adaptation |
| --- | --- |
| [Tactical Mich/Fast Helmet, 10094020550](https://create.roblox.com/store/asset/10094020550), RK2903 | One MeshPart, zero scripts. VEX helmet; fitted to Head and combined with original orange visor/respirator. Mesh 3744222272, texture 3797942365. |
| [tactical vest, 5017067006](https://create.roblox.com/store/asset/5017067006), wilzadlroblox2 | Hat/Handle/SpecialMesh, zero scripts. Keep only geometry; discard old Weld and TouchTransmitter. VEX carrier; mesh 108788572, texture 109282716. SpecialMesh.Scale is fitted independently from Handle.Size. |
| Native Roblox R15 body geometry | Created in Studio through `Players:CreateHumanoidModelFromDescriptionAsync` with an empty description. Retain 14 body MeshParts only; remove native scripts, joints, attachments and other children. The project's skeleton/poses, human head, armor, silhouettes and loadouts are constructed separately. Not a third-party complete character. |

The two listings were free in Creator Store during this review and are used under Roblox's Creator Store terms. This is not a CC0 or independently verified copyright-ownership claim. Templates store asset references for use in the Roblox game, not extracted model/texture binaries.

### Original meshes created using Roblox AI tools

AI-generated content is disclosed in CREDITS. Meshes were created for this project with original, franchise-free prompts, reviewed and adapted. Roblox's [AI terms, User Terms §8 / Creator Terms §6](https://en.help.roblox.com/hc/en-us/articles/115004647846-Roblox-Terms-of-Use) apply; no CC0 or exclusive-rights claim is made. Templates retain `RBX_AI_*` provenance attributes. Mounted submodels also retain a source generation ID. There is no runtime generation dependency.

| Template / use | Generated model asset ID | Generation ID |
| --- | --- | --- |
| TITAN helmet/cuirass | 88111549621491 | a7a4f0e6-8e6f-4ace-8066-dd2605a3441f |
| ATLAS helmet/cuirass | 133520932251416 | bd1badff-6514-4090-a904-72c8c34e75e2 |
| PHANTOM helmet/cuirass | 87702344536786 | 40f31493-9be8-4c72-a939-3eab72d3e51e |
| HAVOC helmet/cuirass | 85253785342661 | c441b14d-c939-4238-bb54-1ad523a1a081 |
| SPECTRE hood/cuirass | 102552779592253 | 02278c56-60bd-4b78-a79e-7ecbbfcddcdc |
| NOVA helmet/cuirass | 90764627647212 | 29673b53-f0d3-428c-8402-2bb1955ca19e |
| ECHO cuirass | 101283055798326 | 25b5ae14-6b9f-4561-b38a-113300df221a |
| ECHO replacement helmet | 134447682164731 | a91d2c9d-4f58-4159-b537-a959ab3ee541 |
| Common shoulder shell | 134333291768677 | ee923e22-25eb-4332-b18d-f2faf7d643d0 |
| Common forearm shell | 87969396582212 | 7fd4b805-2bc4-4992-970f-0c0fcfae435f |
| Common shin/thigh shell | 121340322991487 | 2daf53c4-5242-4290-bf00-962f36353306 |
| VX-7 rifle | 118294909464160 | 23a1f5a2-4c21-4660-996b-3df4a2cbc3d6 |
| M-90 cannon | 98043531056828 | 165b040b-3847-4c01-8342-d00dc6d7d467 |
| ATLAS gauntlet | 113022494110404 | 405dff41-8533-4d5f-9c3f-58cc831d872b |
| PHANTOM pistol | 89394478339582 | 5d1400db-635b-449d-a666-3c5e05c1e75b |
| HAVOC launcher | 81185312750716 | e977329a-9eda-4248-9127-6aa4f8766746 |
| SPECTRE precision rifle | 130001920285597 | 32a9a732-b449-4b38-9020-2234f10742a0 |
| NOVA carbine | 100021937929427 | d891f658-ff77-4339-a23a-1753f5aeffe3 |
| ECHO pulse carbine | 87206430203482 | bde58dfa-a8cb-4bc9-aab1-98e2b6df199b |

These are generated model IDs under the connected Studio creator, not assertions of public/free Creator Store listings. Exact mesh/texture IDs are in the checked-in templates. Kit generation was capped at 7,500 triangles for the entire source kit; only selected usable pieces are retained. Common shells were each capped at 1,200 triangles, weapons at 1,800 (SPECTRE 1,200). These ceilings are not measured final triangle counts or GPU benchmarks. Reused shells share mesh content. Invisible hit volumes do not render, and menus instantiate one hero at a time.

Rejected generation output includes paired limbs in one rigid mesh, duplicate torsos, an incorrect tiny ECHO helmet and a VEX chest resembling a backpack. The generated multi-weapon kit (107093074162639) also produced unusable segmentation and is not shipped. Original VEX kit 107131219044702 is superseded by the two Creator Store pieces above. Raw sources remain in Studio `ServerStorage.ZeroAssetReview.GeneratedSources`; exports omit unwanted package links and contain no executable code. Generation retries hit character limits, publication rate limits and a play-mode context error; successful replacement assets above are the ones retained.

### User-provided live Studio assets

The user authorized modification/use of all supplied models. That authorization does not identify the original third-party terms. No external scripts were found or executed.

| Studio model | Audit / useful category | Decision |
| --- | --- | --- |
| PBR Star Wars Blasters | 108 MeshParts in a multi-weapon kit; zero LuaSourceContainers. Recognizable franchise weapon names/designs; PBR maps present. | Not shipped: no original source/license supplied. The game's weapons use independent generated meshes. |
| Reinhardt | 27 descendants, mostly UnionOperations; no humanoid/R15 joints; zero scripts. Potential armor geometry, but recognizable existing game character. | Not shipped: source/license absent and not R15-ready. TITAN receives independent fitted armor. |
| hats (two duplicate Models) | Each has two ShocktrooperAccessory handles/SpecialMeshes, old Weld/TouchInterest/value/attachment nodes; zero scripts. Mesh 4773564713, textures 5179075023 / 5192221650. | Not shipped: MarketplaceService identified textures as `odst_bake` / `odst_bake4`, by EnamelMammal; mesh creator GuestCapone. Original licensing/use scope remains unidentified. |

Their geometry is preserved unchanged under **`ServerStorage.ZeroAssetReview.UserProvided`** in the existing Place1 Studio project, keeping loose prefab collision out of the playable arena. They are not silently deleted or included in the GitHub place. To revisit them, supply the original Creator Store/source URLs and permissions covering adaptation in this game; Studio access itself is already working. No additional upload is needed for the assets that are currently integrated.

### Reopening / publishing

Open the newly built place to load mesh-template changes, then connect Rojo for code edits. MeshId and reserved AI provenance writes are restricted during live sync; rebuilding preserves the baked data. The original Studio copies are already installed. For another experience/group owner, grant mesh/texture/audio access or upload permitted source under that owner, update template IDs and rebuild. Verify in a private published experience; local Studio access does not prove all ownership contexts.

## Earlier source and audit history

The initial milestone combined original fitted hero armor/weapons and procedural poses with reviewed free Creator Store art templates and audio. Searches covered sci-fi rifles/helmets, R15 rigs/armor/animations, industrial containers/pipes and harbor cranes. No paid assets were obtained. No Toolbox gameplay code is included.

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

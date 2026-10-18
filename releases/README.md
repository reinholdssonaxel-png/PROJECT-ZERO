# Studio snapshot

`PROJECT-ZERO.rbxlx` is a ready-built Rojo place saved on 2026-10-18 from source commit `14485629e413e739ef183d8c13a509205084904f`. It includes eight fitted mesh-armored human R15 heroes and corresponding weapons, HAMNVERKET v2's protected two-exit spawn routes/sawtooth warehouse, and the server-driven command menu with model rotation/zoom controls.

Download the raw `.rbxlx` file and open it in Roblox Studio. Press **Play**, then **PLAY → TRAINING → DEPLOY VEX** in the command menu. The map builds at runtime. HEROES and ARMORY inspect all eight models/weapons; only VEX's gameplay kit is deployable. A training round has 15-second preparation, 180-second duration and a results-to-menu flow. H inspects during play; M leaves for the menu.

Meshes and audio load from the Roblox asset IDs documented in `docs/ASSETS.md`. They are not packaged as external mesh/audio binaries. No additional manual Toolbox import is needed.

To refresh this snapshot after gameplay changes:

```powershell
rojo build default.project.json -o releases/PROJECT-ZERO.rbxlx
```

The mesh revision passed 6,603 Studio assertions (4,216 moving-armor, 622 hero/art, 1,723 map, 28 combat, 14 session). Actual input selected all eight heroes/weapons and verified VEX movement, firing, reload, Dash and menu return with the new geometry. Earlier menu/timed-round tests remain documented. New sources/provenance, rejected supplied models and remaining published/device/multi-client limits are in docs/ASSETS.md and docs/HERO_ART.md. These are development meshes/poses; VEX is the only playable kit.

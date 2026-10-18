# Studio snapshot

`PROJECT-ZERO.rbxlx` is a ready-built Rojo place saved on 2026-10-18 from source commit `4361b046e6ab2c5140bd7d6986ba531a956697e3`. It includes HAMNVERKET v2's protected two-exit spawn routes and the server-driven main menu.

Download the raw `.rbxlx` file and open it in Roblox Studio. Press **Play**, then **PLAY → TRAINING → DEPLOY VEX** in the command menu. The map builds at runtime. HEROES and ARMORY inspect all eight models/weapons; only VEX's gameplay kit is deployable. A training round has 15-second preparation, 180-second duration and a results-to-menu flow. H inspects during play; M leaves for the menu.

Meshes and audio load from the Roblox asset IDs documented in `docs/ASSETS.md`. They are not packaged as external mesh/audio binaries. No additional manual Toolbox import is needed.

To refresh this snapshot after gameplay changes:

```powershell
rojo build default.project.json -o releases/PROJECT-ZERO.rbxlx
```

The source verification passed 1,851 Studio assertions (1,723 map, 114 combat/hero, 14 session). Physical exit sightlines, four actual bot routes, menu/preview/settings input, actual VEX input and a natural timed training ending were tested. Details and remaining multi-client/published/device gaps are in docs/HAMNVERKET_V2.md and docs/MAIN_MENU.md.

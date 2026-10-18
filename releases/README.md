# Studio snapshot

`PROJECT-ZERO.rbxlx` is a ready-built Rojo place saved on 2026-10-18 from source commit `e4953b9ea91075a48cb684e27e45fba6c6996bfe`. This saving commit changes storage/documentation only; gameplay source is unchanged.

Download the raw `.rbxlx` file and open it in Roblox Studio. Press **Play**; the map builds at runtime. Press **H** to preview all eight heroes. VEX is playable against one AI bot; the other heroes are visual prototypes.

Meshes and audio load from the Roblox asset IDs documented in `docs/ASSETS.md`. They are not packaged as external mesh/audio binaries. No additional manual Toolbox import is needed.

To refresh this snapshot after gameplay changes:

```powershell
rojo build default.project.json -o releases/PROJECT-ZERO.rbxlx
```

The previous source verification passed 114 Studio assertions. This snapshot was rebuilt from that source; no new gameplay features or additional Studio playtest are claimed by this saving commit.

# MiABSFD Free Mobility Mod

Infinite jumps, no fall damage, no natural status decrease, and no Abyss curse.

## Features

- **Infinite jumping.** Hold jump to infinitely move upwards. You can also jump in mid-air. Do not jump too fast, as the camera won't be able to keep up.
- **No fall damage.**
- **No stamina decrease.** Doing actions will not consume stamina.
- **No natural hunger decrease.** Only tested for when you go hungry over time. Other actions like moving levels still consume hunger.
- **No Abyss curse effect.** Going up will no longer trigger the Abyss curse.

> [!WARNING]
> This mod is experimental and might cause your game to crash during gameplay. Please stock up on Mail Balloons and save regularly.

## Installation

Get and install this mod via Nexus Mods and Vortex (guide also in the link): https://www.nexusmods.com/madeinabyssbinarystarfallingintodarkness/mods/7

## Manual / Advanced Installation

1. Get and install UE4SS by following the instructions on this page here: <https://seekerted.github.io/MiABSFD-UE4SS-Guide/>
1. Grab the latest release of this mod.
1. Extract and paste the files into the _executable folder_.

### Uninstalling

To disable just the mod but keep UE4SS, delete `Mods\<this mod's folder>\enabled.txt`. To re-enable the mod, just re-create it (it's an empty text file).

To uninstall everything, simply revert the _executable folder_ back to the state before you pasted everything in.

## Credits

Special thanks to:
- [UE4SS](https://github.com/UE4SS-RE/RE-UE4SS)
- UE4SS Discord
- Made in Abyss: Modding Community Discord

## Changelog

```text
1.0.2
- Updated utils.lua

1.0.1
- Bugfix: set the adding of gameplay tags to only once, instead of on every player spawn.

1.0.0
- Initial release of complete primary features
```
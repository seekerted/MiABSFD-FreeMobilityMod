# MiA BSFD Free Mobility Mod

A mod for MiA: BSFD that allows you to move more freely.

## Features

- **Infinite jumping.** Hold jump to infinitely move upwards. You can also jump in mid-air. Do not quickly tap jump though, as the camera won't be able to keep up.
- **No fall damage.**
- **No stamina decrease.** Doing actions will not consume stamina.
- **No natural hunger decrease.** Only tested for when you go hungry over time. Other actions like moving levels still consume hunger.
- **No Abyss curse effect.** Going up will no longer trigger the Abyss curse.

## Installation

Get and install this mod via Nexus Mods and Vortex (guide also in the link): https://www.nexusmods.com/madeinabyssbinarystarfallingintodarkness/mods/7

## Manual/Advanced Installation

If you've already installed UE4SS previously (maybe from another one of my mods?) you can skip to the mod part.

### Install UE4SS

1. Download [UE4SS Experimental Release v2.5.2-570](https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/experimental) (`UE4SS_v2.5.2-570-g37e727b.zip`).
1. Make a backup of the game's _executable folder_ (`\steamapps\common\MadeInAbyss-BSFD\MadeInAbyss-BSFD\Binaries\Win64`). This is so that you can revert the game back to a clean slate in case something happens.
1. Extract `UE4SS_v2.5.2-570-g37e727b.zip` into the _executable folder_.

### Install this mod

1. Grab the latest release of this repository, or just download/clone.
1. In your copy of the repository, paste all the files inside the top folder into the _executable folder_.
	- If it asks if you want to overwrite files, as long as it's not in the `Mods` folder, then it's fine, it doesn't matter.

## Usage

After doing the above the mod injector (UE4SS) and this mod itself (FreeMobility) should be installed and you can just run the game.

> [!CAUTION]
> This mod is experimental and might cause your game to crash during gameplay. Please stock up on Mail Balloons and save regularly.

This mod only affects game mechanics, so your saves should be unaffected regardless if you have the mod or not, but I'm not 100% sure. **Please create backups always.**

### Uninstalling

To disable just the mod but keep UE4SS, delete `Mods\seekerted-FreeMobility\enabled.txt`. To re-enable the mod, just re-create it (it's an empty text file).

To uninstall everything, simply revert the _executable folder_ back to the state before you pasted everything in (or just deleting `xinput1_3.dll` should suffice).

## Credits

Special thanks to:
- [UE4SS](https://github.com/UE4SS-RE/RE-UE4SS)
- UE4SS Discord
- Made in Abyss: Modding Community Discord

## Changelog

```
1.0.2
- Updated utils.lua

1.0.1
- Bugfix: set the adding of gameplay tags to only once, instead of on every player spawn.

1.0.0
- Initial release of complete primary features
```
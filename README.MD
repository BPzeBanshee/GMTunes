# GMTunes
**GMTunes** is a GameMaker project that aims to eventually serve as a replacement engine for **SimTunes**. A SimTunes installation is required to use the program effectively (and for legal reasons is **not** provided here), but will fallback to placeholder graphics where possible.

**SimTunes** is the product of Maxis and was primarily designed by Toshio Iwai. It is based on "Music Insects", an interactive audio-visual exhibit which was designed and created by Toshio Iwai and featured at the Exploratorium in San Franciso, 1992.

# Installation
Simply extract the compiled project ZIP somewhere. Current builds assume you have attempted to run SimTunes at least once and have at least successfully generated a valid config file at `%LOCALAPPDATA%/VirtualStore/Windows/SimTunes.ini`. The program will then write it's `GMTunes.ini` config file at `%LOCALAPPDATA%/GMTunes` and extract assets to that directory where needed.

## Controls
Most button combos from SimTunes (not all) are reimplemented here, but there's a few exceptions.

- F1: set interpolation on/off
- F2: restart game
- F4: fullscreen toggle
- ALT-F4/ESC: close program
- SPACE: toggle pause/resume of Bugz
- ARROWS/WSAD: move view
- CTRL-B: Bugz selection menu
- +/-: zoom in/out

# Current Status
GMTunes has been in the works on and off for some years but still needs work. A list of supported and unsupported features lies below. 

## Things GMTunes supports
- Intro movie support (utilises gmlibsmacker extension)
- 60 FPS gameplay (game originally ran at 30, configurable via INI)
- Reconstruction of the original SimTunes GUI, and an optional fallback GUI (WIP)
- 'empty' no-Bugz playfield state, can load SimTunes `.bug` files and pick from WIP selection menu
- Level loading of JSON-based `.gmtun` format, SimTunes `.gal` "Gallery" files and `.tun` save files
- Saving games in JSON-based `.gmtun` format and experimental support for SimTunes `.tun` format
- Stamp features (except stamp tiling mode and GUI presets)
- enhanced 'Watch' mode that actually tracks Bugz movement
- Background loading (.BAC files)
- Bugz loading (.BUG files)
- Undo button

## Things GMTunes DOES NOT support at this time
- Help dialog
- Music view of notes (TBA)
- Switching off of control note views (TBA)
- 'Explore' (AKA 'Field') tab features
- Tutorial room not implemented, instead leads to a debug room for testing/research
- Some menus and buttons in UI aren't yet hooked up, most file explorer features using Windows `get_open_filename_ext`
- MIDI support (GM has no native support: requires an extension to be written, MIDI data needs further understanding)
- Configuration menu (planned, but a lot of original INI config options SimTunes had are obsolete)

# Special Thanks
This project would likely never have gotten off the ground without the help of the SimTunes Community Discord server, and particularly the efforts of users 'Yellow' and 'lucasvb'.

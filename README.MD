# GMTunes
**GMTunes** is a GameMaker project that aims to eventually serve as a replacement engine for **SimTunes**. 

It does not provide any copyrighted assets, so while the basic program will *technically* run on placeholder graphics for debugging purposes, you will need a SimTunes installation to load the resources associated with their savegames and use the program effectively.

**SimTunes** is the product of Maxis and was primarily designed by Toshio Iwai. It is based on "Music Insects", an interactive audio-visual exhibit which was designed and created by Toshio Iwai and featured at the Exploratorium in San Franciso, 1992.

# Installation
Simply extract the compiled project ZIP over an existing SimTunes installation. Current builds assume you have attempted to run SimTunes and have at least successfully generated a valid config file at `%LOCALAPPDATA%/VirtualStore/Windows/SimTunes.ini`.

## Controls
- F1: set interpolation on/off
- F2: restart game
- F4: fullscreen toggle
- ALT-F4/ESC: close program
- TAB: change submenu
- SPACE: toggle pause/resume of Bugz
- ARROWS/WSAD: move view
- +/-: zoom in/out

# Current Status
GMTunes has been in the works on and off for some years but still remains in a very early state. A list of supported and unsupported features lies below. Most excrutiating at this time is a timing bug that prevents accurate playback of the Gallery example 'Reverb'.

## Things GMTunes supports
- Intro movie loading
- Background loading (.BAC files)
- Bugz loading (.BUG files), currently does not need Bugz loaded for the initial playfield
- Level loading (.GAL "Gallery" files as well as .TUN save files)
- Placement of notes and control notes via UI, flag placement via number keys 1-4
- 60 FPS (game originally ran at 30)

The file explorer is accessible using the button in left corner of the navigation bar. You can create a new file by clicking the **New file** button in the file explorer. You can also create folders by clicking the **New folder** button.

## Things GMTunes DOES NOT support
- Saving games (WIP but does not work)
- Original GUI and it's assets (WIP, requires LZARI/`TUNERES.DAT` decoding/extraction)
- MIDI support (requires an extension to be written)
- Stamp support (planned)
- Configuration menu (planned, but a lot of original menu options are obsolete)
- Internal folder browser (planned, uses Windows `get_open_filename_ext` for now)

# Special Thanks
This project would likely never have gotten off the ground without the help of the SimTunes Community Discord server, and particularly the efforts of users 'Yellow' and 'lucasvb'.

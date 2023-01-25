# TerminalSetup

Download [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads)

Download and install "Oh My Posh" for [Windows](https://ohmyposh.dev/docs/installation/windows) or for [Linux/wsl](https://ohmyposh.dev/docs/installation/linux)

- For Linux setup:
  - add the content of .bashrc to the **.bashrc** in your home directory.
- Windows setup
  - Download and install [VsCode](https://code.visualstudio.com/download)
  - execute ``` install_extensions.ps1 ```
  - add lines of **vscode/settings.json** to your **settings.json**
  - Download and install [Windows Terminal](https://aka.ms/terminal)
    - select as font "CaskaydiaCove NF"

## Linux autosetup: setup.sh

To use this script locate yourself in the root of this repo, ```sudo chmod +x setup.sh``` the just execute it.

This script will move the confiuration files in your home directory, install the requireed dependencies, then TODO setup and modify your .bashrc if needed.

## Windows autosetup: setup.ps1 TODO
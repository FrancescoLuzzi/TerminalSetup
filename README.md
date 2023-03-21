# TerminalSetup

Download [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads) -> Inastall all .otf files with "Windows Compatible" in their name (install for all users)

Download and install "Oh My Posh" for [Windows](https://ohmyposh.dev/docs/installation/windows) or for [Linux/wsl](https://ohmyposh.dev/docs/installation/linux)

- For Linux setup:
  - run ``` sudo apt install git bash-completion curl tree zip vim vim-gui-common vim-runtime tmux -y ```
  - add the content of .bashrc to the **.bashrc** in your home directory.
- Windows setup
  - Download and install [VsCode](https://code.visualstudio.com/download)
  - Execute ``` install_extensions.ps1 ```
  - Add lines of **vscode/settings.json** to your **settings.json**
  - Download and install [Windows Terminal](https://aka.ms/terminal)
    - select as font "CaskaydiaCove NF"
  - Check if virtualization is enabled in your bios
  - Execute ``` wsl --install ``` and follow [wsl install guide](https://learn.microsoft.com/en-us/windows/wsl/install)

## Linux autosetup: setup.sh

To use this script locate yourself in the root of this repo, ```sudo chmod +x setup.sh``` the just execute it.

This script will move the confiuration files in your home directory, install the requireed dependencies, then TODO setup and modify your .bashrc if needed.

## Windows autosetup: setup.ps1 TODO

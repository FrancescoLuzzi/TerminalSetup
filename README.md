# TerminalSetup

Download [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads) -> Inastall all .otf files with "Windows Compatible" in their name (install for all users)

Download and install "Oh My Posh" for [Windows](https://ohmyposh.dev/docs/installation/windows) or for [Linux/wsl](https://ohmyposh.dev/docs/installation/linux)

- Windows setup
  - Download and install [VsCode](https://code.visualstudio.com/download)
  - Execute ``` install_extensions.ps1 ```
  - Add lines of **vscode/settings.json** to your **settings.json**
  - Download and install [Windows Terminal](https://aka.ms/terminal)
    - select as font "CaskaydiaCove NF"
  - Check if virtualization is enabled in your bios
  - Execute ``` wsl --install ``` and follow [wsl install guide](https://learn.microsoft.com/en-us/windows/wsl/install)

## Linux setup: setup.sh

``` chmod +x setup.sh && ./setup -I ```

To use this script locate yourself in the root of this repo, ```sudo chmod +x setup.sh``` the just execute it.

This script will install and configure the developement enviroment with what you need:

- install oh
- install [vim](https://www.vim.org/)/[lvim](https://www.lunarvim.org/) or none
- install [tmux](https://github.com/tmux/tmux)/[zellij](https://github.com/zellij-org/zellij) none
- python (python3-dev, python3-pip, python3-venv)
- golang
- rust
- node (nvm, latest lts node)

Notes:

- to add and update tmux packages  ``` tmux new ``` then ``` Ctrl+<Space> +I ```

## Windows autosetup: setup.ps1 TODO

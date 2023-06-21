# TerminalSetup

Download [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads) -> Install all .ttf files for all users 

Download and install "Oh My Posh" for [Windows](https://ohmyposh.dev/docs/installation/windows) or for [Linux/wsl](https://ohmyposh.dev/docs/installation/linux)

- Windows setup
  - Download and install [Windows Terminal](https://aka.ms/terminal)
    - select as font "CaskaydiaCove NF"
  - Check if virtualization is enabled in your bios

## Linux setup: setup.sh

```bash
sudo apt update && sudo apt upgrade && sudo apt install curl
```

```bash
curl -o- https://raw.githubusercontent.com/FrancescoLuzzi/TerminalSetup/main/remote_setup.sh | bash
```

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

## Windows autosetup: setup.ps1
 
 ```posershell
 (Invoke-WebRequest https://raw.githubusercontent.com/FrancescoLuzzi/TerminalSetup/main/remote_setup.ps1).Content | powershell -
 ```

 Installs:
 
 - downloads and installs vscode, then links `keybindings.json` and `settings.json`
 - [initialize wsl](https://learn.microsoft.com/en-us/windows/wsl/install) `wsl --install -d Debian`
 - Executes `install_vscode_extensions.ps1`

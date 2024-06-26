# TerminalSetup

Download [Cascadia Code](https://github.com/microsoft/cascadia-code/releases/latest) -> Install all .ttf files for all users

Download and install "Oh My Posh" for [Windows](https://ohmyposh.dev/docs/installation/windows) or for [Linux/wsl](https://ohmyposh.dev/docs/installation/linux)

## Linux setup: setup.sh

```bash
sudo apt update && sudo apt upgrade && sudo apt install curl
```

```bash
curl -o- https://raw.githubusercontent.com/FrancescoLuzzi/TerminalSetup/main/remote_setup.sh | bash
```

This script will install and configure the developement enviroment with what you need:

- install and configure oh-my-posh (always)
- install [vim](https://www.vim.org/)/[nvim](https://neovim.io/) or none
- install [tmux](https://github.com/tmux/tmux)/[zellij](https://github.com/zellij-org/zellij) none
- python (python3-dev, python3-pip, python3-venv)
- golang
- rust
- node (nvm, latest lts node)

Notes:

- to add and update tmux packages `tmux new` then `Ctrl+<Space>+I`

## Windows autosetup: setup.ps1

**N.B.** da eseguire come amministratore

```powershell
# enable execution of powershell scripts
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force
```

```powershell
# start setup
(Invoke-WebRequest https://raw.githubusercontent.com/FrancescoLuzzi/TerminalSetup/main/remote_setup.ps1 -UseBasicParsing).Content | powershell -
```

```powershell
# set execution policy to default config
Set-ExecutionPolicy -ExecutionPolicy Default -Scope CurrentUser -Force
```

**Check if virtualization is enabled in your bios**

Installs:

- if not installed, downloads and install vscode
- links `keybindings.json` and `settings.json`
- Executes `install_vscode_extensions.ps1`
- `-wsl` [initialize wsl](https://learn.microsoft.com/en-us/windows/wsl/install) `wsl --install -d Debian`
- `-theme` copies the theme and the background image
- `-neovim`, install and configure neovim
  - [**Prerequisite**] install [gcc Mingw64](https://winlibs.com/#download-release)
  - installs make [`winget install gnuwin32.make`]
  - installs neovim [`winget install Neovim.Neovim` or from github]

Download and install [Windows Terminal](https://aka.ms/terminal), then edit the Json config file:

```jsonc
{
    //...
    "profiles":
    {
        "defaults":
        {
            "backgroundImage": "desktopWallpaper",
            "backgroundImageOpacity": 0.3,
            "colorScheme": "Campbell",
            "font": {
                "face": "Cascadia Code NF"
            },
            "opacity": 100,
            "bellStyle": "none"
        },
        //...
    }
    //...
}
```

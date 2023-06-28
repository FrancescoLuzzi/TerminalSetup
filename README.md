# TerminalSetup

Download [Caskaydia Cove Nerd Font](https://www.nerdfonts.com/font-downloads) (download v2.3.3 for now) -> Install all .ttf files for all users

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

- to add and update tmux packages `tmux new` then `Ctrl+<Space> +I`

## Windows autosetup: setup.ps1

```posershell
(Invoke-WebRequest https://raw.githubusercontent.com/FrancescoLuzzi/TerminalSetup/main/remote_setup.ps1).Content | powershell -
```

**Check if virtualization is enabled in your bios**

Installs:

- if not installed, downloads and install vscode
- links `keybindings.json` and `settings.json`
- Executes `install_vscode_extensions.ps1`
- `-wsl` [initialize wsl](https://learn.microsoft.com/en-us/windows/wsl/install) `wsl --install -d Debian`
- `-theme` copies the theme and the background image
- (WIP) installs nvim on windows
  - install [gcc Mingw64](https://winlibs.com/#download-release)
  - install make [`winget install gnuwin32.make`]
  - install nvim [`winget install Neovim.Neovim` or from github]

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
                "face": "CaskaydiaCove NF"
            },
            "opacity": 100,
            "bellStyle": "none"
        },
        //...
    }
    //...
}
```

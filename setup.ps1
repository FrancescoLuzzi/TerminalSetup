param(
  [switch]$vscode,
  [switch]$vscode_settings,
  [switch]$theme,
  [switch]$wsl,
  [switch]$neovim
)

# install vscode
if ($vscode) {
  code --version >$null
  if (! $?) {
    $build = 'stable'
    $os = 'win32-x64-user'
    $SourceURL = "https://code.visualstudio.com/sha/download?build=$build&os=$os";
    $Installer = $env:TEMP + "\vscode.exe";
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest $SourceURL -OutFile $Installer;
    Start-Process -FilePath $Installer -Args "/mergetasks=!runcode,addcontextmenufiles,addcontextmenufolders,addtopath,desktopicon" -Wait;
    Remove-Item $Installer;
  }
  ./vscode/install_vscode_extensions.ps1
}

# set vscode bindings when either one of the vscode switch are set
if ($vscode_settings -or $vscode) {
  code --version >$null
  if ($?) {
    New-Item -ItemType HardLink -Path $env:APPDATA/Code/User/keybindings.json -Target $HOME/.terminal_setup/vscode/keybindings.json -Force
    New-Item -ItemType HardLink -Path $env:APPDATA/Code/User/settings.json -Target $HOME/.terminal_setup/vscode/settings.json -Force
  }
}

# set theme
if ($theme) {
  Copy-Item -Force $HOME/.terminal_setup/theme/DarkWolf.theme $HOME/AppData/Local/Microsoft/Windows/Themes/DarkWolf.theme
  Copy-Item -Recurse -Force $HOME/.terminal_setup/theme/DesktopBackground $HOME/AppData/Local/Microsoft/Windows/Themes/RoamedThemeFiles
}

# setup wsl
if ($wsl) {
  wsl --install -d Debian
  Write-Host "After setting up for the first time your wsl instance you can follow the linux tutorial to set up that enviroment!"
}

# setup neovim
if ($neovim) {
  gcc --version >$null
  if (! $?) {
    Write-Warning "Can't continue with Neovim installation.`nMingw[32|64] not installed, download from https://winlibs.com/#download-release and add it's bin folder to `$PATH"
    return
  }
  winget install gnuwin32.make
  # if some problem occurs while cloning neovim packages using git,
  # try `git config --global http.sslbackend schannel`
  # https://stackoverflow.com/questions/57327608/ssl-certificate-problem-self-signed-certificate-in-certificate-chain
  winget install Neovim.Neovim
  # https://github.com/BurntSushi/ripgrep#installation
  winget install BurntSushi.ripgrep.MSVC
  Remove-Item -Force -ErrorAction Ignore $env:LOCALAPPDATA/nvim
  New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA/nvim -Target $HOME/.terminal_setup/linux_terminal/nvim
}
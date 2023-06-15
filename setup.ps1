param(
  [switch]$wsl
)
$build = 'stable'
$os = 'win32-x64-user' 
$SourceURL = "https://code.visualstudio.com/sha/download?build=$build&os=$os";
$Installer = $env:TEMP + "\vscode.exe"; 
Invoke-WebRequest $SourceURL -OutFile $Installer;
Start-Process -FilePath $Installer -Args "/mergetasks=!runcode,addcontextmenufiles,addcontextmenufolders,addtopath,desktopicon" -Wait; 
Remove-Item $Installer;

New-Item -ItemType HardLink -Path $env:APPDATA/Code/User/keybindings.json -Target $HOME/.terminal_setup/keybindings.json -Force
New-Item -ItemType HardLink -Path $env:APPDATA/Code/User/settings.json -Target $HOME/.terminal_setup/settings.json -Force

./vscode/install_vscode_extensions.ps1

if($wsl){
  wsl --install -d Debian
  echo "After setting up for the first time your wsl instance you can follow the linux tutorial to set up that enviroment!"
}
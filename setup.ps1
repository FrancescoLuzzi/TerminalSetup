# Unattended Install of Visual Studio Code

$build = 'stable'
$os = 'win32-x64-user' 
$SourceURL = "https://code.visualstudio.com/sha/download?build=$build&os=$os";
$Installer = $env:TEMP + "\vscode.exe"; 
Invoke-WebRequest $SourceURL -OutFile $Installer;
Start-Process -FilePath $Installer -Args "/verysilent /tasks=!runcode,addcontextmenufiles,addcontextmenufolders,addtopath" -Wait; 
Remove-Item $Installer;
Stop-Process -Name Explorer



New-Item -ItemType HardLink -Path $env:APPDATA/Code/User/keybindings.json -Target $HOME/.terminal_setup/keybindings.json -Force
New-Item -ItemType HardLink -Path $env:APPDATA/Code/User/settings.json -Target $HOME/.terminal_setup/settings.json -Force
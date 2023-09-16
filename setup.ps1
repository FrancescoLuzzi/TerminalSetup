param(
  [switch]$vscode,
  [switch]$vscode_settings,
  [switch]$theme,
  [switch]$wsl,
  [switch]$neovim
)
# escape char
$e = "$([char]27)"

$GreenCheck = "$e[92m$([char]8730)"

$RedCross =  "$e[91mX"

# setting up spinner and exit messages
$__stopping_states = @{"Failed" = "Execution failed $RedCross"; "Stopped" = "Exetuction stopped $RedCross"; "Completed" = "Done $GreenCheck"}
# $__frames = @('┤','┘','┴','└','├','┌','┬','┐')
$__frames = @([char]9508,[char]9496,[char]9524,[char]9492,[char]9500,[char]9484,[char]9516,[char]9488)
$__framesCount = $__frames.count
$__frameInterval = 125

function Wait-JobWithSpinner {
  <#
    .SYNOPSIS
    Wait for a job in a pretty way
    .PARAMETER Job
    Job to be waited
    .PARAMETER Message
    Message to display with the spinner
  #>
  Param(
    [Parameter(Mandatory = $true)]
    [System.Management.Automation.Job]
    $Job,

    [Parameter(Mandatory = $true)]
    [string]
    $Message
  )
  # escape sequence documentation
  # https://learn.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences
  # $frameLength = $Message.Length + $__frames[0].Length
  $frameLength = $Message.Length + 1
  # save current cursor position, and hide cursor ($e[?25l)
  write-host "$e[s$e[?25l" -NoNewline
  for (($i = 0); $true; $i++) {
    $frame = $__frames[$i % $__framesCount]
    # reset cursor position and write
    Write-Host "$e[u$frame $Message" -NoNewline
    Start-Sleep -Milliseconds $__frameInterval
    if ( $null -eq $Job -or $__stopping_states.ContainsKey($Job.State) ) {
      $__out_string = $__stopping_states[$Job.State]
      # restore cursor position, delete next $frameLength chars and write "Done", and enable cursor show ($e[?25h)
      Write-Host "$e[u$e[$frameLength`P$__out_string$e[?25h"
      break
    }
  }
}


function Resolve-PathForced {
  <#
    .SYNOPSIS
    Calls Resolve-Path but works for files that don't exist.
    .REMARKS
    From http://devhawk.net/blog/2010/1/22/fixing-powershells-busted-resolve-path-cmdlet
  #>
  param (
    [string] $FileName
  )

  $FileName = Resolve-Path $FileName -ErrorAction SilentlyContinue -ErrorVariable _frperror
  if (-not($FileName)) {
    $FileName = $_frperror[0].TargetObject
  }

  return $FileName
}

function Start-JobCustom() {
  <#
    .SYNOPSIS
    Start and wait execution of a job
    .DESCRIPTION
    Execute a job a wait its execution, also handles Ctrl+C displaying pretty messages
    .PARAMETER JobBody
    Code that needs to be executed from a Job (to use local vars $var -> $using:var)
    .PARAMETER Message
    Message to be displayed while waiting job
    .PARAMETER BaseDir
    Move $pwd of the Job to $BaseDir
    .INPUTS
    None. You cannot pipe objects to Start-JobCustom
  #>
  param (
    [Parameter(Mandatory = $true)]
    [System.Management.Automation.ScriptBlock]
    $JobBody,

    [Parameter(Mandatory = $true)]
    [String]
    $Message,

    [Parameter(Mandatory = $false)]
    [String]
    $BaseDir = "."
  )
  $__stopped = $true
  try {
    $__job = (Start-Job -Init ([ScriptBlock]::Create("Set-Location '$BaseDir'"))  -ScriptBlock $JobBody)
    Wait-JobWithSpinner $__job "$Message"
    $__stopped = $false
  }
  finally {
    if ($__stopped) {
      $__job | Stop-Job
      $__out_string = $__stopping_states.Stopped
      # reset cursor, erase current line ($e[K), then write $__out_string and enable cursor show ($e[?25h)
      Write-Host "$e[u$e[K$__out_string$e[?25h"
    }
  }
}

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
    $__job_body = {
      New-Item -ItemType HardLink -Path $env:APPDATA/Code/User/keybindings.json -Target $HOME/.terminal_setup/vscode/keybindings.json -Force
      New-Item -ItemType HardLink -Path $env:APPDATA/Code/User/settings.json -Target $HOME/.terminal_setup/vscode/settings.json -Force
      Start-Sleep -Milliseconds 500
    }
    Start-JobCustom $__job_body "Copying vscode settings..."
  }
}

# set theme
if ($theme) {
  $__job_body = {
    Copy-Item -Force $HOME/.terminal_setup/theme/DarkWolf.theme $HOME/AppData/Local/Microsoft/Windows/Themes/DarkWolf.theme
    Copy-Item -Recurse -Force $HOME/.terminal_setup/theme/DesktopBackground $HOME/AppData/Local/Microsoft/Windows/Themes/RoamedThemeFiles
    Start-Sleep -Milliseconds 500
  }
  Start-JobCustom $__job_body "Copying theme..."
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
  $__job_body = {
    # https://github.com/BurntSushi/ripgrep#installation
    $packages = @("gnuwin32.make", "Neovim.Neovim", "BurntSushi.ripgrep.MSVC")
    foreach($package in $packages){
      winget install $package --accept-package-agreements --accept-source-agreements --silent --uninstall-previous
    }
    Remove-Item -Force -Recurse -ErrorAction Ignore $env:LOCALAPPDATA/nvim
    New-Item -Force -ItemType SymbolicLink -Path $env:LOCALAPPDATA/nvim -Target $HOME/.terminal_setup/linux_terminal/nvim
  }
  # if some problem occurs while cloning neovim packages using git,
  # try `git config --global http.sslbackend schannel`
  # https://stackoverflow.com/questions/57327608/ssl-certificate-problem-self-signed-certificate-in-certificate-chain
  Start-JobCustom $__job_body "Setting up Neovim..."
}
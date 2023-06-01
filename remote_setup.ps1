git --version >$null
if (! $?){
    winget install --id Git.Git -e --source winget
}

cd $HOME

git clone git clone https://github.com/FrancescoLuzzi/TerminalSetup.git .terminal_setup

cd .terminal_setup

./setup.ps1
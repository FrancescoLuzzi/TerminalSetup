#!/bin/bash

# load nvm just to be sure
source ~/.nvm/nvm.sh 2>/dev/null

_pwd=$(pwd)
ln -sf ${_pwd}/linux_terminal/.vimrc $HOME/.vimrc
ln -sf ${_pwd}/linux_terminal/.git.plugin.sh $HOME/.git.plugin.sh
ln -sf ${_pwd}/linux_terminal/.luzzi_theme.omp.json $HOME/.luzzi_theme.omp.json
ln -sf ${_pwd}/linux_terminal/.tmux.conf $HOME/.tmux.conf

is_ping_usable=$(
    ping -q -c 1 -W 1 8.8.8.8 1>/dev/null 2>&1
    echo $?
)

if [ $is_ping_usable = "2" ]; then
    echo "Enabling use of ping in wsl"
    sudo setcap cap_net_raw+p /bin/ping
fi

if ! nvm --version; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    source ~/.nvm/nvm.sh
fi

if ! node --version; then
    nvm install --lts
fi

if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    # start a server but don't attach to it
    tmux start-server
    # source .tmux.conf
    tmux source $HOME/.tmux.conf
    # create a new session but don't attach to it either
    tmux new-session -d
    # install the plugins
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
    # killing the server is not required, I guess
    tmux kill-server
fi

# idea for installer

# if nothing is passed, interactive mode (aks continue [Y/n]?, if n return helper and exit)

# by default apt install:
# build-essential libssl-dev libffi-dev
if [ -e ~/.terminal_setup/.setted_up]; then
    exit 1
fi

# options
# -h show help
# -i [vim|nvim] (installs -p -G -r -n)
# -w [tmux|zelij]
# -p (python3-dev, python3-pip, python3-venv)
# -r (rust+cargo)
# -n (nvm+node+npm)
# -g (golang)
# -o (install and configure oh-my-posh)
# -U (update)
# -I (interactive install)

# we ended correctly, create file ~/.terminal_setup/.setted_up
# all calls without option -u will result in failure with explanation

showHelp() {
    # `cat << EOF` This means that cat should stop reading when EOF is detected
    cat >&2 <<EOF
Usage: ./installer [-hvrV] args
Install Pre-requisites for EspoCRM with docker in Development mode

-h                   Display help

-v                   Set and Download specific version of EspoCRM

-r                   Rebuild php vendor directory using composer and compiled css using grunt

-V                   Run script in verbose mode. Will print out each step of execution.

EOF
    # EOF is found above and hence cat command stops reading. This is equivalent to echo but much neater when printing out.
}

### SOURCES
# multiple output overwrite:
# - https://unix.stackexchange.com/questions/360198/can-i-overwrite-multiple-lines-of-stdout-at-the-command-line-without-losing-term

# important variables for installation
# $editor, contains which editor to install
# $window_manager, contains which window_manager to install
# $programs, array that contains which extra programs to install

unset pid_to_watch
declare -a pid_to_watch

function dots() {
    printf "%0.s." $(seq $1)
}

function interactive_install() {
    unset SCREEN
    local __el_line=$(tput el1)
    local __up_one_line=$(tput cuu1)

    function restore_screen() {
        tput rmcup
    }

    function save_screen() {
        tput smcup
    }

    function is_selected() {
        egrep -q ".+ \*.*$" <<<"$1"
        return $?
    }

    function unselect_text() {
        echo "$1" | awk -F ' *' '{print $1}'
    }

    function toggle_text() {
        if is_selected "$1"; then
            uselect_text $1
        else
            echo "$1 *"
        fi
    }

    ### custom_select
    # clear terminal and prints selections
    # there are options to save the state of the terminal before selection
    # and to restore the terminal to that state
    function custom_select() {
        # $@ elements to be displayed
        # $PS3 variable containing prompt before selection
        # $SCREEN variable to determine if screen should be saved and restored
        #  - $SCREEN = "none" or not set -> do nothing [DEFAULT]
        #  - $SCREEN = "restore" -> save and restore terminal
        #  - $SCREEN = "save" -> save terminal
        # N.B. $SCREEN will be set to "none" after execution
        # $REPLY variable containing number selected
        # $item variable containing item selected

        if [ $SCREEN == "save" -o $SCREEN == "restore" ]; then
            save_screen
            $SCREEN="none"
        fi

        tput clear
        tput sc
        while true; do
            local i=1
            for el in "$@"; do
                echo "$i) $el"
                ((i++))
            done
            read -p "$PS3"
            if [[ $REPLY =~ ^[0-9]+$ && $REPLY -le $# ]]; then
                item=${!REPLY}
                break
            fi
            tput rc
            tput ed
            echo "Error during selection"
        done
        if [ $SCREEN == "restore" ]; then
            restore_screen
        fi
    }

    PS3="Select editor to be installed: "

    items=("vim" "nvim" "lvim" "none" "quit")

    SCREEN="save"
    while true; do
        custom_select "${items[@]}"
        case $REPLY in
        0) ;;
        [1-4])
            echo "Editor selection done!"
            break
            ;;
        5)
            echo "Quitting... bye!"
            exit 0
            ;;
        esac
    done

    unset editor
    editor=$item

    PS3="Select terminal window manager to be installed: "

    items=("tmux" "zellij" "none" "quit")

    while true; do
        custom_select "${items[@]}"
        case $REPLY in
        [1-3])
            echo "Terminal window manager selection done!"
            break
            ;;
        4)
            echo "Quitting... bye!"
            exit 0
            ;;
        esac
    done

    unset window_manager
    window_manager=$item

    PS3="Select programs to be installed: "

    items=("golang" "node" "python" "rust" "done" "quit")
    err_str="(since $editor selected)"
    if [ $editor == "vim" ]; then
        items[1]="$(toggle_text ${items[1]}) $err_str"
    elif [ $editor == "lvim" ]; then
        items[1]="$(toggle_text ${items[1]}) $err_str"
        items[2]="$(toggle_text ${items[2]}) $err_str"
        items[3]="$(toggle_text ${items[3]}) $err_str"
    fi

    while true; do
        custom_select "${items[@]}"
        case $REPLY in
        2)
            if [ $editor == "vim" ]; then
                continue
            fi
            ;;&
        [2-4])
            if [ $editor == "lvim" ]; then
                continue
            fi
            ;;&
        5)
            echo "Selection done!"
            break
            ;;
        6)
            echo "Quitting... bye!"
            exit 0
            ;;
        *)
            items[$REPLY - 1]=$(toggle_text "$item")
            ;;
        esac
    done

    unset programs
    declare -a programs

    for program in "${items[@]}"; do
        if is_selected $program; then
            programs+=("$(unselect_text $program)")
        fi
    done
    unset items
    restore_screen
}

function get_github_release_artifact_url() {
    # $1 author name
    # $2 repo name
    # $3 release tag
    # $4 filename searched
    if [ $# -ne 3 ]; then
        return 1
    fi
    curl -L \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/repos/$1/$2/releases/tags/$3 |
        grep browser_download_url |
        cut -d '"' -f 4 |
        grep "$4$"
}

function download_github_release_artifact() {
    local file_name=$(basename $1)
    wget $1 -r -O $file_name
    echo $file_name
}

echo "unlock sudo for this installation!"
sudo echo "done"
sudo apt update >/dev/null 2>&1 &
pid_to_watch+=("$?")
sudo apt upgrade -y >/dev/null 2>&1 &
pid_to_watch+=("$?")
sudo apt install git bash-completion curl wget tree zip build-essential libssl-dev libffi-dev -y >/dev/null 2>&1 &
pid_to_watch+=("$?")

unset i
i=0
while true; do
    # go up one line
    echo setting up$(dots "$i")
    i=$((++i % 3))
    if ! ps "${pid_to_watch[@]}" >/dev/null; then
        break
    fi
    sleep 0.5
    echo -e "$__up_one_line$__el_line\c"
done

_pwd=$(pwd)
ln -sf ${_pwd}/linux_terminal/.vimrc $HOME/.vimrc
ln -sf ${_pwd}/linux_terminal/.git.plugin.sh $HOME/.git.plugin.sh
ln -sf ${_pwd}/linux_terminal/.luzzi_theme.omp.json $HOME/.luzzi_theme.omp.json
if ! nvm; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi
source ~/.bashrc

if ! node; then
    nvm install --lts
fi

# install oh-my-posh
# sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
# sudo chmod +x /usr/local/bin/oh-my-posh

#!/bin/bash

# filename: setup.sh
# author: @FrancescoLuzzi

showHelp() {
    cat >&2 <<EOF
Usage: ./installer [-i vim|lvim] [-w tmux|zellij] [-IU] [-gnopr]
Install Pre-requisites for EspoCRM with docker in Development mode

-h                   Display help

-I                   Interactive installer

-U                   Update terminal setup after first installation

-e [vim|lvim]        Optional text editor with custom configuration

-w [tmux|zellij]     Optional window manager with custom keybindings and packages

-g                   Install golang for developement

-n                   Install nvm/node/npm for developement (also installed with lvim and vim)

-p                   Install python for developement (also installed with lvim)

-r                   Install rust for developement (also installed with lvim)
EOF

}

if [ $# -eq 0 ]; then
    showHelp
    exit 0
fi

_pwd=$(pwd)

function in_docker(){
    [ -e /.dockerenv ] || [ $IN_DOCKER == "true" ]
}

function install_golang() {
    local latest_go_version="$(curl --silent https://go.dev/VERSION?m=text)";

    echo "Downloading and installing $latest_go_version"

    curl -OJ -L https://golang.org/dl/$latest_go_version.linux-amd64.tar.gz

    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf $latest_go_version.linux-amd64.tar.gz

    if ! grep -q 'export PATH=$PATH:/usr/local/go/bin' ~/.bashrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.bashrc
        source "~/.bashrc"
    fi

    if [ ! -d ~/go ]; then
        mkdir ~/go
    fi
    rm ./$latest_go_version.linux-amd64.tar.gz
}

function install_node() {
    if ! nvm --version >/dev/null 2>&1; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
        source ~/.nvm/nvm.sh
    fi

    if ! node --version >/dev/null 2>&1; then
        nvm install --lts
    fi

    if [ ! -d ~/node ]; then
        mkdir ~/node
    fi
}

function install_rust() {
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf >rustup-init.sh
    chmod +x rustup-init.sh
    ./rustup-init.sh -y
    if [ ! -d ~/rust ]; then
        mkdir ~/rust
    fi
    rm rustup-init.sh
    source "$HOME/.cargo/env"
}

function install_python() {
    sudo apt install python3-dev python3-pip python3-venv -y

    python3 -m pip install --upgrade pip
    if [ ! -d ~/python ]; then
        mkdir ~/python
    fi
}

function install_vim() {
    sudo apt install vim vim-gui-common vim-runtime -y
    ln -sf ${_pwd}/linux_terminal/.vimrc $HOME/.vimrc
    vim +'PlugInstall --sync' +qa
}

function get_github_latest_tag() {
    # $1 author name
    # $2 repo name
    if [ $# -ne 2 ]; then
        return 1
    fi
    curl -s -L \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/repos/$1/$2/tags |
        grep -m 1 name |
        cut -d '"' -f 4
}

function get_github_release_artifact_url() {
    # $1 author name
    # $2 repo name
    # $3 release tag
    # $4 filename searched
    if [ $# -ne 4 ]; then
        return 1
    fi
    curl -s -L \
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

function install_nvim() {
    local url=$(get_github_release_artifact_url neovim neovim "v0.8.3" "nvim.appimage")
    local file=$(download_github_release_artifact $url)
    if in_docker ; then
        mkdir -p /tmp/nvim
        chmod a+x ./$file
        mv ./$file /tmp/nvim
        cd /tmp/nvim
        ./nvim.appimage --appimage-extract
        sudo ln -sf /tmp/nvim/squashfs-root/AppRun /usr/local/bin/nvim
        cd -
    else
        sudo apt install fuse
        chmod u+x ./$file
        mv ./$file /usr/local/bin/nvim
    fi
}

function install_lvim() {
    install_nvim
    curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh -o install.sh
    chmod +x install.sh
    if [ -z ${LV_BRANCH+x} ]; then
        export LV_BRANCH='release-1.2/neovim-0.8'
    fi
    ./install.sh -y --no-install-dependencies
    rm install.sh
    if ! grep -q 'export PATH=/root/.local/bin:$PATH' ~/.bashrc; then
        echo 'export PATH=/root/.local/bin:$PATH' >>~/.bashrc
        echo 'alias vim=lvim' >>~/.bashrc
        echo 'alias vi=lvim' >>~/.bashrc
    fi
    if ! grep -q 'lvim.transparent_window = true' ~/.config/lvim/config.lua;then
        cat ${_pwd}/linux_terminal/config.lua >>~/.config/lvim/config.lua
    fi
}

function install_tmux() {
    sudo apt install tmux -y
    ln -sf ${_pwd}/linux_terminal/.tmux.conf $HOME/.tmux.conf
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
}

function install_zellij() {
    local url=$(get_github_release_artifact_url zellij-org zellij $(get_github_latest_tag zellij-org zellij) "zellij-x86_64-unknown-linux-musl.tar.gz")
    local file=$(download_github_release_artifact $url)
    tar xzvf $file
    sudo install zellij /usr/local/bin
    rm $file
}

function install_oh_my_posh() {
    if ! oh_my_posh --version 2>/dev/null; then
        sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
        sudo chmod +x /usr/local/bin/oh-my-posh
    fi
    ln -sf ${_pwd}/linux_terminal/.theme.omp.json $HOME/.theme.omp.json

    if ! grep -q 'eval "$(oh-my-posh --init --shell bash --config ~/.theme.omp.json)"' ~/.bashrc; then
        echo 'eval "$(oh-my-posh --init --shell bash --config ~/.theme.omp.json)"' >>~/.bashrc
    fi
}

unset editor
unset window_manager
unset programs
interactive=false
update=false
declare -a programs

while getopts ':IUgnpre:w:' OPTION; do
    case $OPTION in
    h)
        showHelp
        exit 0
        ;;

    I)
        interactive=true
        ;;

    U)
        update=true
        ;;

    e)
        if [[ $OPTARG =~ (^vim$|^lvim$) ]]; then
            editor=$OPTARG
        else
            echo "unsupported value for -e: $OPTARG"
            showHelp
            exit 0
        fi
        ;;

    w)
        if [[ $OPTARG =~ (^tmux$|^zellij$) ]]; then
            window_manager=$OPTARG
        else
            echo "unsupported value for -w: $OPTARG"
            showHelp
            exit 0
        fi
        ;;

    g)
        program+=("golang")
        ;;

    n)
        program+=("node")
        ;;

    p)
        program+=("python")
        ;;

    r)
        program+=("rust")
        ;;

    ?)
        showHelp
        exit 1
        ;;
    esac
done

# getopts cycles over $*, doesn't shift it
shift $(($OPTIND - 1))

# by default apt install:
# build-essential libssl-dev libffi-dev
if ! $update && [ -e ~/.terminal_setup/.setted_up ]; then
    echo 'terminal already setup, run "setup.sh -h" for help'
    exit 1
fi
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

function __wait() {
    # $1 output
    # launch it in bg and kill it with "kill %1"
    local output=$1
    shift
    local i=0
    while true; do
        # go up one line
        echo -e "\r$output$(dots $(($i + 1)))"
        i=$((++i % 3))
        sleep 0.5
        tput el
        tput cuu1
        tput el
    done
}

function interactive_install() {
    unset SCREEN

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
            unselect_text $1
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
                echo -e "\r$i) $el"
                ((i++))
            done
            read -p "$(echo -e "\r$PS3")"
            REPLY=$(echo "$REPLY" | tr -d '[:space:]')
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

    if [ -z ${editor+x} ]; then
        PS3="Select editor to be installed: "

        items=("vim" "lvim" "none" "quit")

        SCREEN="save"
        while true; do
            custom_select "${items[@]}"
            case $REPLY in
            [1-3])
                echo "Editor selection done!"
                break
                ;;
            4)
                echo "Quitting... bye!"
                exit 0
                ;;
            esac
        done

        editor=$item
    fi

    if [ -z ${window_manager+x} ]; then
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

        window_manager=$item
    fi

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
        2) # node
            if [ $editor == "vim" ]; then
                continue
            fi
            ;;&
        [2-4]) # node, python, rust
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

    programs=()

    for program in "${items[@]}"; do
        if is_selected "$program"; then
            programs+=("$(unselect_text "$program")")
        fi
    done
    unset items
    restore_screen
}

if [ "$UP_TO_DATE" != "up to date" ]; then
    echo "unlock sudo for this installation!"
    sudo echo "done"
    __wait "setting up" &
    sudo apt update >/dev/null 2>&1
    sudo apt upgrade -y >/dev/null 2>&1
    sudo apt -y install git bash-completion curl wget tree zip build-essential libssl-dev libffi-dev  >/dev/null 2>&1

    kill %1
fi

# interactive install
if $interactive; then
    interactive_install
fi

# load nvm just to be sure
source ~/.nvm/nvm.sh 2>/dev/null

ln -sf ${_pwd}/linux_terminal/.git.plugin.sh $HOME/.git.plugin.sh
if ! grep -q 'source ~/.git.plugin.sh' ~/.bashrc; then
    echo 'source ~/.git.plugin.sh' >>~/.bashrc
fi

is_ping_usable=$(
    ping -q -c 1 -W 1 8.8.8.8 1>/dev/null 2>&1
    echo $?
)

if [ $is_ping_usable = "2" ]; then
    echo "Enabling use of ping in wsl"
    sudo setcap cap_net_raw+p /bin/ping
fi

install_oh_my_posh

for program in "${programs[@]}"; do
    case $program in
    golang)
        install_golang
        ;;

    node)
        install_node
        ;;

    python)
        install_python
        ;;

    rust)
        install_rust
        ;;

    esac

done

if [ $editor == "vim" ]; then
    install_vim
elif [ $editor == "lvim" ]; then
    install_lvim
fi

if [ $window_manager == "tmux" ]; then
    install_tmux
elif [ $window_manager == "zellij" ]; then
    install_zellij
fi

touch ~/.terminal_setup/.setted_up

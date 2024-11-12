#!/bin/bash

# filename: setup.sh
# author: @FrancescoLuzzi

showHelp() {
    cat >&2 <<EOF
Usage: ./setup.sh [-e vim|nvim] [-w tmux|zellij] [-IU] [-gnopr]

-h                   Display help

-I                   Interactive installer

-U                   Update terminal setup after first installation

-e [vim|nvim]        Optional text editor with custom configuration

-w [tmux|zellij]     Optional window manager with custom keybindings and packages

-g                   Install golang for development

-n                   Install nvm/node/npm for development

-p                   Install python for development

-r                   Install rust for development

-z                   Install zig for development
EOF

}

if [ $# -eq 0 ]; then
    showHelp
    exit 0
fi

_pwd=$(pwd)

function in_docker() {
    [ -e /.dockerenv ] || [ "$IN_DOCKER" = "true" ]
}

function in_set() {
    # $1 array-set variable name
    # $2 element to be checked

    # get array from variable
    eval __arr="(\"\${$1[@]}\")"
    for item in "${__arr[@]}"; do
        [[ "$2" == "$item" ]] && return 0
    done
    unset __arr
    return 1
}

function add_to_set() {
    # $1 array-set variable name
    # $2 element to be added
    if ! in_set "$1" "$2"; then
        eval "$1+=(\"$2\")"
    fi
}

function remove_from_set() {
    # $1 array-set variable name
    # $2 element to be removed
    eval __arr="(\"\${$1[@]}\")"
    for i in "${!__arr[@]}"; do
        if [ "${__arr[i]}" = "$2" ]; then
            unset '__arr[i]'
        fi
    done
    eval $1="(\"\${__arr[@]}\")"
    unset __arr
}

function install_golang() {
    local latest_go_version="$(curl --silent https://go.dev/VERSION?m=text | head -n1)"
    local go_out="golang.tar.gz"

    echo "Downloading and installing $latest_go_version"

    curl -J -L "https://go.dev/dl/$latest_go_version.linux-amd64.tar.gz" -o $go_out

    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf $go_out
    
    if ! grep -q 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' ~/.bashrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
    fi

    if [ ! -d ~/go ]; then
        mkdir ~/go
    fi
    rm $go_out
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

function install_zig() {
    local latest_tag=$(get_github_latest_tag ziglang zig)
    local tar_ball="zig-linux-x86_64-${latest_tag}"
    curl --proto '=https' --tlsv1.2 https://ziglang.org/download/${latest_tag}/${tar_ball}.tar.xz -S -O
    tar xJvf $tar_ball.tar.xz
    sudo rm -rfv /usr/local/zig
    sudo mv -v $tar_ball /usr/local/zig
    if [ ! -d ~/zig ]; then
        mkdir ~/zig
    fi
    if ! grep -q 'export PATH=$PATH:/usr/local/zig' ~/.bashrc; then
        echo 'export PATH=$PATH:/usr/local/zig' >>~/.bashrc
    fi
    rm $tar_ball.tar.xz
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
        https://api.github.com/repos/$1/$2/releases/latest |
        jq -cr ".tag_name"
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
        jq -cr ".assets[] |select(.name == \"$4\") | .browser_download_url"
}

function download_github_release_artifact() {
    local file_name=$(basename $1)
    wget $1 -r -O $file_name
    echo $file_name
}

function install_just() {
    local td=$(mktemp -d || mktemp -d -t tmp)
    local latest_tag=$(get_github_latest_tag casey just)
    local artifact_file="just-${latest_tag}-x86_64-unknown-linux-musl.tar.gz"
    local url=$(get_github_release_artifact_url casey just $latest_tag $artifact_file)
    local file=$(download_github_release_artifact $url)
    tar -C "$td" -xzf "$artifact_file"
    sudo install "$td/just" /usr/local/bin
    rm -r "$artifact_file" "$td"
}

function install_nvim() {
    local url=$(get_github_release_artifact_url neovim neovim "v0.10.2" "nvim.appimage")
    local file=$(download_github_release_artifact $url)
    if in_docker; then
        mkdir -p /tmp/nvim
        chmod a+x ./$file
        mv ./$file /tmp/nvim
        cd /tmp/nvim
        ./nvim.appimage --appimage-extract
        sudo ln -sf /tmp/nvim/squashfs-root/AppRun /usr/local/bin/nvim
        cd -
    else
        sudo apt install fuse -y
        chmod u+x ./$file
        sudo mv ./$file /usr/local/bin/nvim
    fi
    # backup old nvim config
    if file ~/.config/nvim | grep -q 'directory'; then
        mv ~/.config/nvim ~/.config/nvim_bck
    fi
    ln -sfT ${_pwd}/linux_terminal/nvim $HOME/.config/nvim
}

function install_tmux() {
    sudo apt install tmux -y
    ln -sf ${_pwd}/linux_terminal/.tmux.conf $HOME/.tmux.conf
    sudo ln -sf ${_pwd}/linux_terminal/scripts/tmux-sessionizer /usr/bin/tmux-sessionizer
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
    local latest_tag=$(get_github_latest_tag zellij-org zellij)
    local url=$(get_github_release_artifact_url zellij-org zellij $latest_tag "zellij-x86_64-unknown-linux-musl.tar.gz")
    local file=$(download_github_release_artifact $url)
    tar xzvf $file
    sudo install zellij /usr/local/bin
    rm $file
}

function install_oh_my_posh() {
    if ! oh-my-posh --version 2>/dev/null; then
        sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
        sudo chmod +x /usr/local/bin/oh-my-posh
    fi
    ln -sf ${_pwd}/linux_terminal/.theme.omp.json $HOME/.theme.omp.json

    if ! grep -q 'eval "$(oh-my-posh --init --shell bash --config ~/.theme.omp.json)"' ~/.bashrc; then
        echo 'eval "$(oh-my-posh --init --shell bash --config ~/.theme.omp.json)"' >>~/.bashrc
    fi
}

unset editor
editor=""

unset window_manager
terminal_multiplexer=""

unset programs
interactive=false
update=false
declare -a programs

mkdir -p ~/.config

while getopts ':IUghnprze:w:' OPTION; do
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
        if [ "$OPTARG" = "vim" ]; then
            editor=$OPTARG
        elif [ "$OPTARG" = "nvim" ]; then
            editor=$OPTARG
        else
            echo "unsupported value for -e: $OPTARG"
            showHelp
            exit 0
        fi
        ;;

    w)
        if [[ "$OPTARG" =~ (^tmux$|^zellij$) ]]; then
            terminal_multiplexer=$OPTARG
        else
            echo "unsupported value for -w: $OPTARG"
            showHelp
            exit 0
        fi
        ;;

    g)
        add_to_set programs "golang"
        ;;

    n)
        add_to_set programs "node"
        ;;

    p)
        add_to_set programs "python"
        ;;

    r)
        add_to_set programs "rust"
        ;;

    z)
        add_to_set programs "zig"
        ;;

    ?)
        echo "Flag \"-${OPTARG}\" not recognized"
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

echo "unlock sudo for this installation!"
sudo echo "done"

### SOURCES
# multiple output overwrite:
# - https://unix.stackexchange.com/questions/360198/can-i-overwrite-multiple-lines-of-stdout-at-the-command-line-without-losing-term

# important variables for installation
# $editor, contains which editor to install or ""
# $window_manager, contains which window_manager to install or ""
# $programs, array that contains which extra programs to install or empty array

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

    function clean_stdin() {
        while read -e -t 0.1; do :; done
    }

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

        if [ "$SCREEN" = "save" -o "$SCREEN" = "restore" ]; then
            save_screen
            $SCREEN="none"
        fi

        tput clear
        tput sc
        local __ask_out=$(echo -e "\r$PS3")
        while true; do
            local i=1
            for el in "$@"; do
                echo -e "\r$i) $el"
                ((i++))
            done
            clean_stdin
            read -p "$__ask_out"
            REPLY=$(echo "$REPLY" | tr -d '[:space:]')
            if [[ $REPLY =~ ^[0-9]+$ && $REPLY -le $# ]]; then
                item=${!REPLY}
                break
            fi
            tput rc
            tput ed
            echo "Error during selection"
        done
        if [ "$SCREEN" = "restore" ]; then
            restore_screen
        fi
    }

    if [ -z "${editor}" ]; then
        PS3="Select editor to be installed: "

        items=("vim" "nvim" "none" "quit")
        items_len=${#items[@]}

        SCREEN="save"
        while true; do
            custom_select "${items[@]}"
            case $REPLY in
            $items_len)
                echo "Quitting... bye!"
                exit 0
                ;;
            *)
                echo "Editor selection done!"
                break
                ;;
            esac
        done

        editor=$item
    fi

    if [ -z "${terminal_multiplexer}" ]; then
        PS3="Select terminal multiplexer to be installed: "

        items=("tmux" "zellij" "none" "quit")
        items_len=${#items[@]}

        while true; do
            custom_select "${items[@]}"
            case $REPLY in
            $items_len)
                echo "Quitting... bye!"
                exit 0
                ;;
            *)
                echo "Terminal multiplexer selection done!"
                break
                ;;
            esac
        done

        terminal_multiplexer=$item
    fi

    PS3="Select programs to be installed: "

    items=("node" "python" "rust" "golang" "zig" "done" "quit")
    items_len=${#items[@]}

    while true; do
        custom_select "${items[@]}"
        case $REPLY in
        $((items_len - 1)))
            echo "Selection done!"
            break
            ;;
        $items_len)
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
            unselected_program=$(unselect_text "$program")
            add_to_set programs "$unselected_program"
        fi
    done
    unset items
    restore_screen
}

if [ "$UP_TO_DATE" != "up to date" ]; then
    __wait "setting up" &
    sudo apt update >/dev/null 2>&1
    sudo apt upgrade -y >/dev/null 2>&1
    sudo apt install -y file jq git bash-completion curl wget tree ripgrep fzf zip build-essential libssl-dev libffi-dev libicu-dev >/dev/null 2>&1
    install_just
    # kill __wait
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

if [ "$is_ping_usable" = "2" ]; then
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

    zig)
        install_zig
        ;;
    esac

done

if [ "$editor" = "vim" ]; then
    install_vim
elif [ "$editor" = "nvim" ]; then
    install_nvim
fi

if [ "$terminal_multiplexer" = "tmux" ]; then
    install_tmux
elif [ "$terminal_multiplexer" = "zellij" ]; then
    install_zellij
fi

source ~/.bashrc

touch ~/.terminal_setup/.setted_up

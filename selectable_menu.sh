#!/bin/bash


function is_selected(){
    egrep -q ".+ \*$" <<< "$1"
    return $?
}

function toggle_text(){
    if is_selected "$1" ;then
        echo "${1::-2}"
    else
        echo "$1 *"
    fi
}
el_line=$(tput el1)
up_one_line=$(tput cuu1)

function delete_last_lines(){
    echo -e $el_line$(printf "%0.s$up_one_line$el_line" $(seq $1))\c
}

PS3="Select items to be installed: "

items=("Vim" "Nvim" "Tmux")
number_options=$((${#items[@]} + 4))
while true; do
    select item in "${items[@]}" Done Quit
    do
        case $REPLY in
            $((${#items[@]}+1))) echo "Selection done!"; break 2;;
            $((${#items[@]}+2))) echo "We're done! Bye bye"; exit 0;;
            *) if [ $REPLY -le ${#items[@]} ]; then items[$REPLY-1]=$(toggle_text "$item"); else echo "Ooops - unknown choice $REPLY"; fi; break;
        esac
    done
    delete_last_lines $number_options
done
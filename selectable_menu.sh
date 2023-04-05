#!/bin/bash
DEL_PREV_LINE=$'\r\033[K'

function cursor_to(){
    printf "\033[$1;${2:-1}H"
}

function get_cursor_row(){
    IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}
}

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

PS3="${DEL_PREV_LINE}Select items to be installed: "

items=("Vim" "Nvim" "Tmux")
number_options=$((${#items[@]} + 3))
while true; do
    select item in "${items[@]}" Done Quit
    do
        case $REPLY in
            $((${#items[@]}+1))) echo "Selection done!"; break 2;;
            $((${#items[@]}+2))) echo "We're done! Bye bye"; exit 0;;
            *) if [ $REPLY -le ${#items[@]} ]; then items[$REPLY-1]=$(toggle_text "$item"); else echo "Ooops - unknown choice $REPLY"; fi; break;
        esac
    done
    lastrow=`get_cursor_row`
    cursor_to $(($lastrow - $number_options))
done
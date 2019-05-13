#!/bin/bash

USR="$USER"
SSH_HOST="localhost"
SESSION_MGR="xterm"

help(){
 cat <<HDOC
Usage
	-u	the ssh user to log on with
	-h	the ssh hosts IP address or hostname
	-m	the X command to be run on the ssh host
	-h	show this help message
HDOC
}

while getopts "u:h:m:" opt 2>/dev/null; do
echo $opt|awk '{print tolower($0)}'
	case $(echo $opt|awk '{print tolower($0)}') in
		u) USR=$(echo "$OPTARG") ;;
		h) SSH_HOST=$(echo "$OPTARG") ;;
		m) SESSION_MGR=$(echo "$OPTARG") ;;
		h) help ;;
		default) echo "wrong use"; help ;;
	esac
done

get_free_pos(){
 echo $(( $( pgrep -a Xephyr|sed 's/^.*[:]\([0-9]\+\)$/\1/' | sort -n | tail -1 ) + 1 ))
}

xpos=$(get_free_pos);
echo $xpos

Xephyr -ac -screen 1200x600 -br -reset -terminate ":$xpos" &
DISPLAY=":$xpos.0" ssh -XfC $USR@$SSH_HOST $SESSION_MGR


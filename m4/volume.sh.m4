#!/bin/bash

MIXER="MIXERNAME"
VOLSTEP="VOLSTEPVAL"

showmsg() {
	MSG="$@"
	zenity --info --text="$MSG" &
	MSG_PID="$(ps -ef | grep "[z]enity.*$MSG" | awk '{ print $2 }')"
	sleep 2
	kill -9 $MSG_PID
}

getvol() {
	amixer sget "$MIXER" | awk '/%/ { print gensub(/^.*\[([0-9]+)%\].*$/,"\\1",$0); exit; }' 2> /dev/null
}

ismuted() {
	amixer sget "$MIXER" | grep '\[off\]'
}

volume() {
	if [ "$1" == "up" ]; then
		[[ $(getvol) -lt 100 ]] && amixer sset "$MIXER" $[ $(getvol) + $([[ $(getvol) -lt $VOLSTEP && $(getvol) -ne 0 ]] && echo "$[ $VOLSTEP % $(getvol) ]" || echo "$VOLSTEP") ]% || amixer sget "$MIXER"
		exit $(getvol)
	fi

	if [ "$1" == "down" ]; then
		[[ $(getvol) -gt 0 ]] && amixer sset "$MIXER" $[ $(getvol) - $([[ $(getvol) -lt $VOLSTEP && $(getvol) -ne 0 ]] && echo "$[ $VOLSTEP % $(getvol) ]" || echo "$VOLSTEP") ]% || amixer sget "$MIXER"
		exit $(getvol)
	fi

	if [ "$1" == "mute" ]; then
		if [ -n "$(ismuted)" ]; then
			amixer sset "$MIXER" unmute
			exit $(getvol)
		else
			amixer sset "$MIXER" mute
			exit -1
		fi
	fi

	if [ "$1" == "level" ]; then
		if [ -n "$(ismuted)" ]; then
			exit -1
		else
			exit $(getvol)
		fi
	fi
}

volume $(basename $0 | sed 's/volume-\([^\.]\+\)\.sh$/\1/g')

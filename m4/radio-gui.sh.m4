#!/bin/bash

PLAYLIST="PLPATH"

while true; do
	STATION="$(awk 'BEGIN { FS="," } /^#EXTINF/ { print $2 }' < $PLAYLIST | zenity --list --column="Station" --width=300 --height=530)"
	
	if [ $? -eq 1 ]; then
		break
	fi
	
	URL="$(grep -A1 $STATION $PLAYLIST | tail -n1)"
	
	ffplay -loglevel 8 -nodisp "$URL" &
	
	zenity --info --text="Playing\n$STATION" --width=300 --ok-label="Stop"
	
	FFPLAY_PID="$(ps -ef | grep "[f]fplay.*$URL" | awk '{ print $2 }')"
	
	kill -9 $FFPLAY_PID
done

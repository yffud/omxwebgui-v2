#!/bin/bash

#set -x

OMXPLAYER_DBUS_ADDR="/tmp/omxplayerdbus.root"
OMXPLAYER_DBUS_PID="/tmp/omxplayerdbus.root.pid"
if [ ! -f $OMXPLAYER_DBUS_ADDR ]; then
    OMXPLAYER_DBUS_ADDR="/tmp/omxplayerdbus.$USER"
    OMXPLAYER_DBUS_PID="/tmp/omxplayerdbus.$USER.pid"
    if [ ! -f $OMXPLAYER_DBUS_ADDR ]; then
        OMXPLAYER_DBUS_ADDR="/tmp/omxplayerdbus."
        OMXPLAYER_DBUS_PID="/tmp/omxplayerdbus..pid"
    fi
fi
export DBUS_SESSION_BUS_ADDRESS=`cat $OMXPLAYER_DBUS_ADDR`
export DBUS_SESSION_BUS_PID=`cat $OMXPLAYER_DBUS_PID`

[ -z "$DBUS_SESSION_BUS_ADDRESS" ] && { echo "Must have DBUS_SESSION_BUS_ADDRESS" >&2; exit 1; }

case $1 in
status)
	duration=`dbus-send --print-reply=literal --session --reply-timeout=500 --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Duration"`
	[ $? -ne 0 ] && exit 1
	duration="$(awk '{print $2}' <<< "$duration")"

	position=`dbus-send --print-reply=literal --session --reply-timeout=500 --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Position"`
	[ $? -ne 0 ] && exit 1
	position="$(awk '{print $2}' <<< "$position")"

	playstatus=`dbus-send --print-reply=literal --session --reply-timeout=500 --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"PlaybackStatus"`
	[ $? -ne 0 ] && exit 1
	playstatus="$(sed 's/^ *//;s/ *$//;' <<< "$playstatus")"

	source=$(dbus-send --print-reply=literal --session --reply-timeout=500 --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.GetSource)
	[ $? -ne 0 ] && exit 1
	source="$(echo -e "${source}" | tr -d '[:space:]')"

	echo "{\"duration\": \"$duration\", \"position\": \"$position\", \"status\": \"$playstatus\", \"source\": \"$source\"}"
	;;

volume)
	volume=`dbus-send --print-reply=double --session --reply-timeout=500 --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Set string:"org.mpris.MediaPlayer2.Player" string:"Volume" ${2:+double:}$2`
	[ $? -ne 0 ] && exit 1
	volume="$(awk '{print $2}' <<< "$volume")"
	echo "{\"volume\": \"$volume\"}"
	;;

pause)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Action int32:16 >/dev/null
	echo 1
	;;

stop)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Action int32:15 >/dev/null
	echo 1
	;;

seek)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Seek int64:$2 >/dev/null
	echo 1
	;;

setposition)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.SetPosition objpath:/not/used int64:$2 >/dev/null
	echo 1
	;;

setalpha)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.SetAlpha objpath:/not/used int64:$2 >/dev/null
	echo 1
	;;

setvideopos)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.VideoPos objpath:/not/used string:"$2 $3 $4 $5" >/dev/null
	echo 1
	;;

setvideocroppos)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.SetVideoCropPos objpath:/not/used string:"$2 $3 $4 $5" >/dev/null
	echo 1
	;;

setaspectmode)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.SetAspectMode objpath:/not/used string:"$2" >/dev/null
	echo 1
	;;

hidevideo)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Action int32:28 >/dev/null
	echo 1
	;;

unhidevideo)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Action int32:29 >/dev/null
	echo 1
	;;

volumeup)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Action int32:18 >/dev/null
	echo 1
	;;

volumedown)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Action int32:17 >/dev/null
	echo 1
	;;

togglesubtitles)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Action int32:12 >/dev/null
	echo 1
	;;

hidesubtitles)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Action int32:30 >/dev/null
	echo 1
	;;

showsubtitles)
	dbus-send --print-reply=literal --session --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Action int32:31 >/dev/null
	echo 1
	;;
getsource)
	source=$(dbus-send --print-reply=literal --session --reply-timeout=500 --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.GetSource)
	[ $? -ne 0 ] && exit 1
	source="$(echo -e "${source}" | tr -d '[:space:]')"
	echo "{getsource: \"$source\"}"
	;;
*)
	echo "usage: $0 status|pause|stop|seek|volumeup|volumedown|setposition [position in microseconds]|hidevideo|unhidevideo|togglesubtitles|hidesubtitles|showsubtitles|setvideopos [x1 y1 x2 y2]|setvideocroppos [x1 y1 x2 y2]|setaspectmode [letterbox,fill,stretch,default]|setalpha [alpha (0..255)]|getsource" >&2
	exit 1
	;;
esac
#!/bin/bash
################################################################################
# pavol.sh - adjust pulseaudio volume
#
# author: mutantmonkey <mutantmonkey@gmail.com>
# based on an article on the archwiki:
# https://wiki.archlinux.org/index.php/PulseAudio#volume_control
################################################################################

device="alsa_output.pci-0000_00_1b.0.analog-stereo"
case "$1" in
	"up")    # increase volume by 1000
		pacmd dump | awk --non-decimal-data '$1~/set-sink-volume/{if ($2~/'${device}'/) {if ($3+1000 > 65535) {system ("pactl "$1" '${device}' "65535)} else {system ("pactl "$1" '${device}' "$3+1000)}}}'
		;;
	"down")  # decrease volume by 1000
		pacmd dump | awk --non-decimal-data '$1~/set-sink-volume/{if ($2~/'${device}'/) {if ($3-1000 < 0) {system ("pactl "$1" '${device}' "0)} else {system ("pactl "$1" '${device}' "$3-1000)}}}'
		;;
	"mute")  # toggle mute
		pacmd dump|awk --non-decimal-data '$1~/set-sink-mute/{if ($2~/'${device}'/) {system ("pactl "$1" '${device}' "($3=="yes"?"no":"yes"))}}'
		;;
esac


#!/bin/sh
#
# Simple script to load/store ALSA parameters (volume...)
#

VOLUME_STATEFILE=/usr/local/etc/volume.state
PCM=PCM
HP=Headphones

case "$1" in
	start)
		echo "Loading sound volume..."
		if [ -f $VOLUME_STATEFILE ]; then
			/usr/bin/amixer set $PCM `sed -n 's/PCM://p' $VOLUME_STATEFILE`
			/usr/bin/amixer set $HP `sed -n 's/HP://p' $VOLUME_STATEFILE`
		fi
		;;
	stop)
		echo "Storing sound volume..."
		PCM_VOL=`amixer get $PCM | sed -n 's/.*Front .*: Playback \([0-9]*\).*$/\1/p' | paste -d "," - -`
		HP_VOL=`amixer get $HP | sed -n 's/.*Front .*: Playback \([0-9]*\).*$/\1/p' | paste -d "," - -`
		printf "PCM:$PCM_VOL\nHP:$HP_VOL\n" > $VOLUME_STATEFILE
		;;
	*)
		echo "Usage: $0 {start|stop}"
		exit 1
esac

exit $?

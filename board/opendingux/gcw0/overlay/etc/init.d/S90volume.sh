#!/bin/sh
#
# Simple script to load/store ALSA parameters (volume...)
#

VOLUME_STATEFILE=/usr/local/etc/volume.state

case "$1" in
        start)
                echo "Loading sound volume..."
                if [ -f $VOLUME_STATEFILE ]; then
                        /usr/bin/amixer set PCM `head -1 $VOLUME_STATEFILE`
                        /usr/bin/amixer set Headphones `head -2 $VOLUME_STATEFILE`
                fi
                ;;
        stop)
                echo "Storing sound volume..."
                PCM_VOL=`amixer get PCM | sed -n 's/.*Front .*: Playback \([0-9]*\).*$/\1/p' | paste -d "," - -`
                HP_VOL=`amixer get Headphones | sed -n 's/.*Front .*: Playback \([0-9]*\).*$/\1/p' | paste -d "," - -`
                printf "$PCM_VOL\n$HP_VOL\n" > $VOLUME_STATEFILE
                ;;
        *)
                echo "Usage: $0 {start|stop}"
                exit 1
esac

exit $?

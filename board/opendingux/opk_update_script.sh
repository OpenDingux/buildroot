#!/bin/sh

cd `dirname $0`

DATE_FILE=./date.txt

export DIALOGOPTS="--colors --no-shadow"
if [ -f "$DATE_FILE" ] ; then
	DATE="`cat $DATE_FILE`"
	export DIALOGOPTS="$DIALOGOPTS --backtitle \"OpenDingux update $DATE\""
fi

echo "screen_color = (RED,RED,ON)" > /tmp/dialog_err.rc

# ----------
# 1. Select and confirm device
# ----------
THISDEVICE=./thisdevice
DEVICE=$($THISDEVICE --detect)
while true; do
	if [ -n "$DEVICE" ]; then
		eval $($THISDEVICE --device $DEVICE | grep DEVICE_NAME)
		if [ -z "$DEVICE_NAME" ]; then
			DEVICE=
			continue
		fi
		DEVICE_LINE="
\Zb\Z3$DEVICE_NAME\Zn
"
		if [ "$DEVICE_SELECTED" -eq 1 ]; then
			TITLE="The selected device is"
		else
			TITLE="We detected this device as"
		fi
		DEVICE_CONFIRMATION="$TITLE:
$DEVICE_LINE
Flashing incorrect firmware will
likely make your device unbootable.

You can select your device from
manually from the list.

Proceed with the current device?"

		dialog --yes-label 'Continue' --no-label 'Select' \
		       --yesno "$DEVICE_CONFIRMATION" 0 0
		if [ $? -eq 0 ] ; then
			break
		fi
	else
		DEVICE_WARNING="\Zb\Z1We could not detect your device\Zn

Flashing incorrect firmware will
likely make your device unbootable.

Please CAREFULLY select your device
manually from the list."

		dialog --defaultno --yes-label 'Select' --no-label 'Exit' \
		       --yesno "$DEVICE_WARNING" 0 0
		if [ $? -ne 0 ] ; then
			exit $?
		fi
	fi

	exec 3>&1
	NEW_DEVICE=$($THISDEVICE --devices $1 | while read i; do
		echo $i | cut -d'-' -f1 | xargs
		echo $i | cut -d'-' -f2- | xargs
	done | tr \\n \\0 | xargs -0 \
		dialog --menu "Select your device from the list" 0 0 3 \
		2>&1 1>&3)
	EXIT_STATUS=$?
	exec 3>&-
	if [ $EXIT_STATUS -ne 0 ] ; then
		continue
	fi

	DEVICE=$NEW_DEVICE
	DEVICE_SELECTED=1
done

# ----------
# 2. Final confirmation
# ----------
DISCLAIMER="\Zb\Z3NOTICE\Zn

While we carefully constructed this
updater, it is possible flaws in
the updater or in the updated OS
could lead to \Zb\Z3data loss\Zn.
We recommend that you \Zb\Z3backup\Zn
all valuable personal data before
you perform the update.

Do you want to update now?"

dialog --defaultno --yes-label 'Update' --no-label 'Cancel' --yesno "$DISCLAIMER" 0 0
if [ $? -ne 0 ] ; then
	exit $?
fi

# ----------
# 3. Flashing
# ----------
clear
echo 'Update in progress - please be patient.'
echo

if [ "$(whoami)" = "root" -a ! -x /usr/sbin/od-update ]; then
	PATH=$(pwd):$PATH FORCE_DEVICE="$DEVICE" ./od-update $1
else
	sudo PATH=$(pwd):$PATH FORCE_DEVICE="$DEVICE" od-update $1
fi

# ----------
# 4. Checking status
# ----------
ERR=$?
if [ $ERR -ne 0 ] ; then
	case $ERR in
		2)
			ERR_MSG="Failed to update rootfs!\nDo you have enough space available?"
			;;
		3)
			ERR_MSG="Failed to update mininit!"
			;;
		4)
			ERR_MSG="Failed to update kernel!"
			;;
		5)
			ERR_MSG="Failed to update modules!"
			;;
		6)
			ERR_MSG="Failed to update bootloader!"
			;;
		7)
			ERR_MSG="Updated rootfs is corrupted!\nPlease report this bug!"
			;;
		8)
			ERR_MSG="Updated mininit is corrupted!\nPlease report this bug!"
			;;
		9)
			ERR_MSG="Updated kernel is corrupted!\nPlease report this bug!"
			;;
		10)
			ERR_MSG="Updated devicetree is corrupted!\nPlease report this bug!"
			;;
		11)
			ERR_MSG="Updated bootloader is corrupted!\nPlease report this bug!"
			;;
		12)
			ERR_MSG="Can't detect the device.\nPlease ensure that you are running a stock firmware"
			;;
		13)
			ERR_MSG="Bootloader file $BOOTLOADER is missing\nPlease report this bug!"
			;;
		14)
			ERR_MSG="Device tree file $DEVICETREE is missing\nPlease report this bug!"
			;;
		*)
			ERR_MSG="Unexpected return code: $ERR\nPlease report this bug!"
			;;
	esac

	export DIALOGRC="/tmp/dialog_err.rc"
	dialog --msgbox "ERROR!\n\n${ERR_MSG}" 0 0
	exit $ERR
fi

# ----------
# 5. Reboot
# ----------
case $1 in
	rs90)
		LAST_KERNEL=START
		LAST_ROOTFS=R
		;;
	gcw0)
		LAST_KERNEL=X
		LAST_ROOTFS=Y
		;;
esac

dialog --msgbox 'Update complete!\nThe system will now restart.\n\n
If for some reason the system fails to boot, try to press the
following keys while powering on the device:\n
- '"$LAST_KERNEL"' to boot the backup kernel,\n
- '"$LAST_ROOTFS"' to boot the backup rootfs.\n
Pressing both keys during the power-on sequence will load the very
same Operating System (kernel + rootfs) you had before upgrading.' 0 0
reboot

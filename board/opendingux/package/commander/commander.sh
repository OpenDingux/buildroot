#!/bin/sh

IFS= read -r -d $'\0' MODEL </sys/firmware/devicetree/base/compatible
case $MODEL in
	rg99)
		exec /usr/libexec/commander --config-prelude /usr/share/commander/commander.rg99.cfg
		;;
	*)
		exec /usr/libexec/commander
esac

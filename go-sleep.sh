#!/bin/bash
#
# Suspend script with kde-lock
# by liksys (c) 2009 v 1.0
#
#####

for user in `w | egrep 'kded4|startkde' | awk '{print $1}'`; do
	su $user -c "dbus-send --session --print-reply --dest=org.freedesktop.ScreenSaver \
		/ScreenSaver org.freedesktop.ScreenSaver.Lock"
done
sleep 2

sync
pm-suspend


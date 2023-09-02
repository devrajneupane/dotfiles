#! /usr/bin/env bash

# move startup programs here

sxhkd &
libinput-gestures &
greenclip daemon &
udiskie -s &
# xautolock -time 10 -locker 'systemctl suspend' -detectsleep -notify 600 -notifier 'betterlockscreen -l' &
# xss-lock betterlockscreen -l &

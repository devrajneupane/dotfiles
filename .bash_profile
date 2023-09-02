# Automatically login to X on tty1
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    source ~/.xprofile
    exec startx -- vt1 -dpi 96 &> /dev/null
    /usr/bin/prime-offload
fi

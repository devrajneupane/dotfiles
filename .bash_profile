# Source environment variables
[ -f "$HOME/.xprofile" ] && source "$HOME/.xprofile"

# Auto Start X at login on tty1
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    startx -- -nolisten tcp -nolisten local vt1 &>/dev/null
elif [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi

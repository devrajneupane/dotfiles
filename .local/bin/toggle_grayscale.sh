#! /usr/bin/env bash

# Path to grayscale shader
SHADER="$HOME/.config/picom/grayscale.glsl"

# Check if the shader file exists
if [ ! -f "$SHADER" ]; then
    notify-send -u critical "Picom" "Shader file not found: $SHADER"
    exit 1
fi

# Function to start picom with grayscale
start_grayscale() {
    pkill picom
    # picom --backend glx --window-shader-fg "$SHADER" -b
    picom --window-shader-fg "$SHADER" -b
}

# Function to start picom normally
start_normal() {
    pkill picom
    picom -b
}

# Check if picom is running with the shader
if pgrep -af "picom.*window-shader-fg"; then
    start_normal
else
    start_grayscale
fi

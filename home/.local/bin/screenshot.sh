#!/bin/sh
mkdir -p ~/Pictures/Screenshots
FILE=~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png
 
grim -g "$(slurp)" "$FILE" && \
    wl-copy < "$FILE" && \
    notify-send "Screenshot saved" "$FILE"
 

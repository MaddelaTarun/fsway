#!/bin/sh

opt=$(printf "Shutdown\nReboot\nSleep\nLogout" |
    fuzzel -dp "Power " --lines 4 --width 30)

case "$opt" in
    "Shutdown") loginctl poweroff || systemctl poweroff ;;
    "Reboot") loginctl reboot || systemctl reboot ;;
    "Sleep") loginctl suspend || systemctl suspend ;;
    "Logout") swaymsg exit ;;
    *) exit 1 ;;
esac

[ "$opt" ] && notify-send "$opt"

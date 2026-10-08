#!/bin/sh
# Setup for the sway dotfiles:
#   1. moves the config files and scripts from home/ into $HOME
#   2. installs the basic software the setup needs
#
#   ./setup.sh              # files + basic packages (asks for sudo)
#   ./setup.sh --files-only # only move the files; install packages yourself
#
# Existing files that differ are backed up to ~/.dotfiles-backup-<timestamp>.
set -eu

SRC=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEST=${HOME:?HOME is not set}
BK="$DEST/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# ---- 1. move config files and scripts into place ---------------------
cd "$SRC/home"
find . -mindepth 1 \( -type f -o -type l \) | while IFS= read -r rel; do
    rel=${rel#./}
    src="$SRC/home/$rel"
    dst="$DEST/$rel"
    if { [ -e "$dst" ] || [ -L "$dst" ]; } && ! cmp -s "$src" "$dst" 2>/dev/null; then
        mkdir -p "$BK/$(dirname "$rel")"
        mv "$dst" "$BK/$rel"
    fi
    mkdir -p "$(dirname "$dst")"
    cp -a "$src" "$dst"
done

chmod +x "$DEST/.local/bin/"* 2>/dev/null || true

# the bundle was made on a machine with home /home/t — rewrite to this home
grep -rlE '/home/t(/|$)' "$DEST/.config" "$DEST/.local/share/applications" \
        2>/dev/null |
    while IFS= read -r f; do
        sed -Ei "s#/home/t(/|$)#$DEST\1#g" "$f"
    done || true

# font cache for the bundled Lilex Nerd Font
command -v fc-cache >/dev/null 2>&1 &&
    fc-cache -f "$DEST/.local/share/fonts" >/dev/null 2>&1 || true

echo "config files and scripts installed"
if [ -d "$BK" ]; then
    echo "replaced files backed up to: $BK"
fi

if [ "${1:-}" = "--files-only" ]; then
    echo "skipping packages (--files-only)"
    exit 0
fi

# ---- 2. basic software ----------------------------------------------
# (everything the sway session, the scripts and the fish aliases need;
#  bigger apps — see README — install manually whenever you want)
PKGS="
# sway desktop session
sway swaybg swayidle swaylock waybar foot fuzzel mako
# shell + prompt + basic tools
fish starship fastfetch git btop neovim eza bat
# what the scripts call (screenshot, clipboard, power menu, media keys)
grim slurp wl-clipboard cliphist brightnessctl libnotify jq
pulseaudio-utils wireplumber
# look + hardware video decode + screen sharing
papirus-icon-theme libva-intel-media-driver xdg-desktop-portal-wlr
"

# strip comment lines, normalize to one line
PKGS=$(echo "$PKGS" | grep -v '^[[:space:]]*#' | tr '\n' ' ')

if [ -n "$PKGS" ] && sudo dnf install -y $PKGS; then
    echo "basic packages installed"
else
    echo "package install skipped/failed — do it manually with:"
    echo "  sudo dnf install $PKGS"
fi

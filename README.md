# Dotfiles — sway setup

Configs, scripts, fonts and wallpaper for a sway desktop. Works as-is on
this machine and on a laptop with only an Intel GPU.

## Setup

```sh
./setup.sh              # basic packages + moves everything into place
./setup.sh --files-only # only moves files (you install packages yourself)
```

Then start the session from a TTY: `sway`

- Files that already exist and differ are backed up to `~/.dotfiles-backup-<timestamp>`
- Re-run `./setup.sh` any time after changing things in `home/`

## What's included in `home/`

- **Configs**: sway (+ `config.d/` for per-machine output tuning), waybar,
  fuzzel, foot, fish, starship, fastfetch, btop, neovim, GIMP, OBS, GTK look
- **Scripts** (`.local/bin`): `sway-intel` (picks the right GPU automatically),
  `helium-hw` (hardware video decode), `clipboard.sh`, `screenshot.sh`,
  `powermenu.sh`, `prime-run`
- **Looks**: Lilex Nerd Font, Notwaita-Black cursor, wallpaper
  (Papirus icons come from the RPM)

## Extra apps — install manually if wanted

```sh
sudo dnf install mpv imv pcmanfm pavucontrol nwg-look obs-studio gimp \
    github-cli tmux fzf ripgrep zoxide
flatpak install flathub com.spotify.Client md.obsidian.Obsidian
gh auth login   # GitHub login is intentionally not bundled
```

Manual installs: Helium (`/opt/helium`) and Vesktop — copy them over or
re-download. Neovim fetches its plugins on first start (needs network).

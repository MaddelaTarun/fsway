Both are already in there — the Notwaita-Black cursor (`home/.local/share/icons/Notwaita-Black/`) and your wallpaper (`home/Pictures/wall4.jpg`) ship with the bundle, and `setup.sh` installs the cursor and rebuilds the font cache automatically.

## Laptop setup, step by step

**1. Copy the bundle over** (on this machine, while both are on the same network):

```sh
scp -r ~/dotfiles user@laptop-ip:~/
```

(Or put it on a USB stick — it's ~106 MB, mostly fonts.)

**2. On the laptop, run:**

```sh
cd dotfiles
./setup.sh
```

This:
- copies all configs, scripts, cursor, fonts and wallpaper into `$HOME`
- backs up any files that already exist to `~/.dotfiles-backup-<timestamp>`
- rewrites the hardcoded `/home/t` paths to your laptop's username
- installs the basic packages (it'll ask for your sudo password)

*(If you'd rather install packages yourself: `./setup.sh --files-only`, then manually run the `sudo dnf install …` line it prints.)*

**3. Make fish your shell** (if it isn't already):

```sh
chsh -s /usr/bin/fish
```

**4. Log out of any existing desktop session**, switch to a TTY (`Ctrl+Alt+F3`), log in and start sway:

```sh
sway
```

Your fish config aliases `sway` to `exec sway`, so typing `sway` is all it takes. From then on you can also launch it from the login screen if the laptop has a display manager.

**5. First-run checks:**
- **Waybar battery/backlight** — the modules are already configured; they'll appear automatically since the laptop has a battery.
- **Wallpaper/output** — works out of the box via `output *`. The bundled `config.d/10-desktop-hdmi.conf` is inert (no such output on the laptop). Only if you ever want to *force* a panel mode: copy `10-laptop-edp.conf.example` → `10-laptop-edp.conf` and uncomment (`swaymsg -t get_outputs` shows names/modes).
- **`sway-intel`** — auto-detects: no NVIDIA on the laptop, so it just runs plain sway. Typing `sway` works identically.
- **Neovim** — will fetch its plugins on first launch (needs internet).
- **GitHub** — run `gh auth login` (credentials were intentionally not bundled).

**6. Optional extras** whenever you want them (from the README):

```sh
sudo dnf install mpv imv pcmanfm pavucontrol nwg-look obs-studio gimp
flatpak install flathub com.spotify.Client md.obsidian.Obsidian
```

Helium and Vesktop aren't packaged — copy `/opt/helium` over or re-download them.

Later, after changing configs on this desktop, re-run `./setup.sh` on the laptop with the refreshed bundle — it's safe to run repeatedly.

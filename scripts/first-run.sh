#!/usr/bin/env bash
set -euo pipefail


# Enable common services
sudo systemctl enable --now NetworkManager bluetooth
systemctl --user enable --now pipewire wireplumber || true


# Start swww daemon in user session
systemctl --user enable --now swww.service


# Create Pictures/Wallpapers if missing
mkdir -p "$HOME/Pictures/Wallpapers"


# Seed a wallpaper if provided in repo presets
if [ -d "$HOME/.config/swww/presets" ]; then
first=$(find "$HOME/.config/swww/presets" -type f | head -n1 || true)
if [ -n "${first:-}" ]; then
"$HOME/dotfiles/scripts/set-wall" "$first"
fi
fi


echo "First run complete. Log into Hyprland and tweak configs in ~/.config."
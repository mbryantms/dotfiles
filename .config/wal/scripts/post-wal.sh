#!/usr/bin/env bash
# Pywal post-generation hook
# This script is automatically executed by pywal after generating colors

set -euo pipefail

# Create symlinks for generated theme files
ln -sf "$HOME/.cache/wal/waybar-wal.css" "$HOME/.config/waybar/wal.css"
ln -sf "$HOME/.cache/wal/colors-mako" "$HOME/.cache/wal/colors-mako"
ln -sf "$HOME/.cache/wal/colors-rofi.rasi" "$HOME/.cache/wal/colors-rofi.rasi"

# Reload GTK theme (if using pywal GTK integration)
if command -v xfsettingsd &>/dev/null; then
    xfsettingsd --replace &>/dev/null &
fi

# Set GTK theme colors
if [ -f "$HOME/.cache/wal/colors-gtk.css" ]; then
    mkdir -p "$HOME/.config/gtk-3.0"
    cat > "$HOME/.config/gtk-3.0/gtk.css" <<EOF
@import url("file://$HOME/.cache/wal/colors-gtk.css");
EOF
fi

# Notify user
notify-send "Theme Updated" "Pywal colors applied successfully" -t 2000 2>/dev/null || true

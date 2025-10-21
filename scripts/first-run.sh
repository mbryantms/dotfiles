#!/usr/bin/env bash
# First-run setup script for Hyprland dotfiles
set -euo pipefail

echo "========================================="
echo "Hyprland Dotfiles - First Run Setup"
echo "========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    error "Do not run this script as root!"
    exit 1
fi

# Create necessary directories
info "Creating directories..."
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/gtk-3.0"
mkdir -p "$HOME/Pictures/Wallpapers"
mkdir -p "$HOME/Pictures/Screenshots"
mkdir -p "$HOME/.cache/wal"

# Copy scripts to ~/.local/bin
info "Installing scripts to ~/.local/bin..."
if [ -d "$HOME/dotfiles/scripts" ]; then
    cp -v "$HOME/dotfiles/scripts/set-wall" "$HOME/.local/bin/"
    cp -v "$HOME/dotfiles/scripts/reload-theme" "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin/set-wall"
    chmod +x "$HOME/.local/bin/reload-theme"
fi

if [ -d "$HOME/dotfiles/.config/hypr/scripts" ]; then
    cp -v "$HOME/dotfiles/.config/hypr/scripts/"* "$HOME/.local/bin/" 2>/dev/null || true
    chmod +x "$HOME/.local/bin/power-menu" 2>/dev/null || true
    chmod +x "$HOME/.local/bin/screenshot" 2>/dev/null || true
fi

# Enable system services
info "Enabling system services..."
if command -v systemctl &>/dev/null; then
    # System services (may require sudo)
    if systemctl list-unit-files | grep -q NetworkManager; then
        sudo systemctl enable --now NetworkManager 2>/dev/null || warn "Failed to enable NetworkManager"
    fi

    if systemctl list-unit-files | grep -q bluetooth; then
        sudo systemctl enable --now bluetooth 2>/dev/null || warn "Failed to enable Bluetooth"
    fi

    # User services
    info "Enabling user services..."
    systemctl --user enable --now pipewire wireplumber 2>/dev/null || warn "Pipewire already enabled or not installed"

    # Enable custom services
    if [ -f "$HOME/.config/systemd/user/swww.service" ]; then
        systemctl --user enable swww.service 2>/dev/null || warn "Failed to enable swww service"
    fi

    if [ -f "$HOME/.config/systemd/user/theme-apply.path" ]; then
        systemctl --user enable theme-apply.path 2>/dev/null || warn "Failed to enable theme-apply path"
    fi
fi

# Check for required packages
info "Checking for required packages..."
MISSING_PACKAGES=()

check_package() {
    if ! command -v "$1" &>/dev/null; then
        MISSING_PACKAGES+=("$2")
    fi
}

check_package "hyprctl" "hyprland"
check_package "waybar" "waybar"
check_package "mako" "mako"
check_package "rofi" "rofi"
check_package "kitty" "kitty"
check_package "wl-copy" "wl-clipboard"
check_package "swww" "swww"
check_package "wal" "python-pywal"
check_package "brightnessctl" "brightnessctl"
check_package "wtype" "wtype"
check_package "jq" "jq"

if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
    warn "Missing packages detected:"
    for pkg in "${MISSING_PACKAGES[@]}"; do
        echo "  - $pkg"
    done
    echo ""
    echo "Install them with:"
    echo "  sudo pacman -S ${MISSING_PACKAGES[*]}"
    echo ""
fi

# Check for screenshot tools (grimblast preferred, grim+slurp fallback)
info "Checking screenshot tools..."
if command -v grimblast &>/dev/null; then
    echo "  ✓ grimblast found (excellent!)"
elif command -v grim &>/dev/null && command -v slurp &>/dev/null; then
    echo "  ✓ grim + slurp found (works, but grimblast is recommended)"
    echo "    Consider: paru -S grimblast-git"
else
    warn "No screenshot tool found!"
    echo "  Install grimblast (recommended): paru -S grimblast-git"
    echo "  OR install grim+slurp: sudo pacman -S grim slurp"
fi

# Set up initial theme
info "Setting up initial theme..."
if command -v wal &>/dev/null; then
    # Look for a default wallpaper
    WALLPAPER=""

    # Check common wallpaper locations
    for dir in "$HOME/Pictures/Wallpapers" "$HOME/Pictures" "/usr/share/backgrounds"; do
        if [ -d "$dir" ]; then
            WALLPAPER=$(find "$dir" -type f \( -iname "*.jpg" -o -iname "*.png" \) -print -quit 2>/dev/null)
            if [ -n "$WALLPAPER" ]; then
                break
            fi
        fi
    done

    if [ -n "$WALLPAPER" ]; then
        info "Found wallpaper: $WALLPAPER"
        info "Generating initial theme..."
        wal -i "$WALLPAPER" -n -t -e || warn "Failed to generate theme"

        # Create symlinks
        ln -sf "$HOME/.cache/wal/waybar-wal.css" "$HOME/.config/waybar/wal.css" 2>/dev/null || true
    else
        warn "No wallpaper found. Add wallpapers to ~/Pictures/Wallpapers/"
        warn "Then run: set-wall /path/to/image.jpg"
    fi
else
    warn "python-pywal not installed. Theming features will not work."
fi

# Set correct permissions on scripts
info "Setting script permissions..."
chmod +x "$HOME/dotfiles/scripts/"* 2>/dev/null || true
chmod +x "$HOME/dotfiles/.config/hypr/scripts/"* 2>/dev/null || true
chmod +x "$HOME/.config/wal/scripts/"* 2>/dev/null || true

# Create GTK configuration
info "Setting up GTK theme..."
if [ ! -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
    cat > "$HOME/.config/gtk-3.0/settings.ini" <<EOF
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
gtk-xft-rgba=rgb
gtk-application-prefer-dark-theme=1
EOF
fi

echo ""
echo "========================================="
echo -e "${GREEN}Setup Complete!${NC}"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Log out and log into Hyprland"
echo "2. Add wallpapers to ~/Pictures/Wallpapers/"
echo "3. Set a wallpaper: set-wall /path/to/image.jpg"
echo "4. Review keybindings in README.md"
echo ""
echo "Useful commands:"
echo "  set-wall <image>    - Set wallpaper and generate theme"
echo "  reload-theme        - Reload theme colors"
echo "  power-menu          - Show power menu"
echo ""
echo "Enjoy your Hyprland setup!"

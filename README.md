# Arch Linux + Hyprland Dotfiles

A comprehensive, modular dotfiles configuration for Arch Linux featuring Hyprland window manager with full pywal integration for dynamic theming.

## Features

- **Hyprland**: Modern Wayland compositor with smooth animations and excellent performance
- **Pywal Integration**: Dynamic color schemes from wallpapers applied across all applications
- **Universal Clipboard**: Omarchy-style unified clipboard shortcuts that work in terminals AND GUI apps
- **Modular Configuration**: Clean, organized configs split into logical files
- **Beautiful UI**: Waybar, Rofi, Mako notifications with consistent theming
- **Productivity Tools**: Tmux, Zsh/Bash with useful aliases and functions
- **Utility Scripts**: Power menu, screenshot tools, wallpaper picker
- **Auto-theming**: Automatic theme reload when wallpaper changes

## Components

### Window Manager & Compositor
- **Hyprland**: Wayland compositor with animations and eye-candy
- **hyprlock**: Screen locker
- **hypridle**: Idle daemon for auto-lock and DPMS

### Status Bar & Notifications
- **Waybar**: Customizable status bar with system information
- **Mako**: Lightweight notification daemon

### Applications
- **Kitty**: GPU-accelerated terminal emulator
- **Rofi**: Application launcher and menu system
- **Thunar**: File manager
- **Firefox**: Web browser

### Theming
- **Pywal**: Automatic color scheme generation from wallpapers
- **swww**: Smooth wallpaper transitions
- **GTK/Qt theming**: Consistent appearance across toolkits

### Utilities
- **grimblast** or **grim + slurp**: Screenshot utilities (grimblast recommended for Hyprland)
- **wl-clipboard**: Clipboard management
- **cliphist**: Clipboard history
- **brightnessctl**: Backlight control
- **pipewire**: Audio server
- **swappy**: Screenshot editor (optional)

## Installation

### Prerequisites

Install required packages:

```bash
# Core Hyprland and components
sudo pacman -S hyprland hyprlock hypridle waybar mako rofi kitty \
    polkit-gnome xdg-desktop-portal-hyprland

# Utilities
sudo pacman -S grim slurp wl-clipboard cliphist brightnessctl \
    swww python-pywal networkmanager bluez bluez-utils \
    pipewire wireplumber pavucontrol thunar wtype

# Fonts
sudo pacman -S ttf-jetbrains-mono-nerd ttf-font-awesome

# Optional but recommended
sudo pacman -S starship zoxide fzf htop tmux neovim firefox \
    jq bc playerctl swappy

# AUR packages (recommended) - use your AUR helper (paru, yay, etc.)
paru -S grimblast-git    # Better screenshot tool for Hyprland
```

### Using GNU Stow (Recommended)

This dotfiles repository is designed to work with GNU Stow for easy management:

```bash
# Install stow
sudo pacman -S stow

# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Stow the dotfiles
stow -v -t $HOME .

# This creates symlinks for all configs in your home directory
```

### Manual Installation

Alternatively, manually copy the configs:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Copy configs
cp -r .config/* ~/.config/
cp .zshrc ~/.zshrc
cp .bashrc ~/.bashrc

# Copy scripts
cp -r scripts ~/.local/bin/
chmod +x ~/.local/bin/*
```

### First Run Setup

After installation, run the first-run script:

```bash
~/dotfiles/scripts/first-run.sh
```

This will:
- Enable required systemd services
- Create necessary directories
- Set up a default wallpaper and theme
- Configure system services

## Configuration

### Hyprland

Main configuration: `~/.config/hypr/hyprland.conf`

Modular configs in `~/.config/hypr/conf.d/`:
- `00-env.conf` - Environment variables, animations, decorations
- `10-input.conf` - Keyboard and mouse settings
- `20-binds.conf` - Keybindings
- `30-rules.conf` - Window rules
- `40-looks.conf` - Theme and appearance
- `45-monitors.conf` - Monitor configuration
- `50-autostart.conf` - Startup applications

### Keybindings

#### Main Keybindings

| Keybind | Action |
|---------|--------|
| `SUPER + Return` | Launch terminal (Kitty) |
| `SUPER + Space` | Application launcher (Rofi) |
| `SUPER + B` | Launch browser (Firefox) |
| `SUPER + E` | File manager (Thunar) |
| `SUPER + Q` | Close window |
| `SUPER + F` | Fullscreen |
| `SUPER + T` | Toggle floating |
| `SUPER + SHIFT + E` | Exit Hyprland |
| `SUPER + SHIFT + X` | Power menu |
| `SUPER + CTRL + L` | Lock screen |

#### Universal Clipboard (Omarchy-style)

These work everywhere - terminals AND GUI applications!

| Keybind | Action |
|---------|--------|
| `SUPER + C` | Copy (works in terminals and apps) |
| `SUPER + V` | Paste (works in terminals and apps) |
| `SUPER + X` | Cut (GUI apps only) |
| `SUPER + CTRL + V` | Clipboard history manager |

**How it works:** Automatically detects terminal windows and sends `Ctrl+Shift+C/V` for terminals or `Ctrl+C/V` for other apps. No more remembering different shortcuts!

#### Window Navigation

| Keybind | Action |
|---------|--------|
| `SUPER + H/J/K/L` | Move focus (vim keys) |
| `SUPER + SHIFT + H/J/K/L` | Move window |
| `SUPER + R` | Enter resize mode |
| `SUPER + 1-0` | Switch workspace |
| `SUPER + SHIFT + 1-0` | Move window to workspace |

#### Screenshots

| Keybind | Action |
|---------|--------|
| `SUPER + S` | Screenshot area to clipboard |
| `SUPER + SHIFT + S` | Screenshot area & save to file |
| `SUPER + CTRL + S` | Screenshot active window & save |
| `SUPER + ALT + S` | Screenshot full screen & save |

**Note:** Uses `grimblast` if installed (recommended), automatically falls back to `grim + slurp`.

#### Wallpaper & Theme

| Keybind | Action |
|---------|--------|
| `SUPER + SHIFT + W` | Wallpaper picker |

### Pywal Theming

The setup automatically generates color schemes from your wallpaper:

```bash
# Set a new wallpaper and theme
~/.local/bin/set-wall ~/Pictures/Wallpapers/your-image.jpg

# Reload theme without changing wallpaper
~/.local/bin/reload-theme
```

Pywal integration affects:
- Waybar colors
- Rofi theme
- Kitty terminal colors
- Mako notification colors
- Hyprland border colors
- GTK applications (partially)

### Universal Clipboard System

Inspired by Omarchy, this setup provides unified clipboard shortcuts that work seamlessly across terminals and GUI applications.

**The Problem:**
- Terminals use `Ctrl+Shift+C/V` for copy/paste
- GUI apps use `Ctrl+C/V` for copy/paste
- You have to remember which shortcut to use where

**The Solution:**
- `Super+C` - Copy (works everywhere)
- `Super+V` - Paste (works everywhere)
- `Super+X` - Cut (GUI apps)

**How it works:**
The universal-clipboard script automatically detects if you're in a terminal window and sends the appropriate key combination:
- **In terminals** (kitty, alacritty, etc.): Sends `Ctrl+Shift+C/V`
- **In other apps**: Sends `Ctrl+C/V`

**Requirements:**
- `wtype` (preferred, installed by default) or `ydotool` (fallback)
- `jq` for JSON parsing

**Supported terminals:**
Automatically detected: kitty, Alacritty, foot, konsole, gnome-terminal, xfce4-terminal, terminator, tilix, and more.

### Monitors

Edit `~/.config/hypr/conf.d/45-monitors.conf` to configure your displays:

```
monitor=DP-1,2560x1440@144,0x0,1
monitor=HDMI-A-1,1920x1080@60,2560x0,1
```

Find your monitor names with: `hyprctl monitors`

### NVIDIA Users

The configuration includes NVIDIA-specific environment variables in `00-env.conf`. If you're not using NVIDIA, comment out these lines:

```
# env = LIBVA_DRIVER_NAME,nvidia
# env = GBM_BACKEND,nvidia-drm
# etc.
```

## Directory Structure

```
dotfiles/
├── .config/
│   ├── hypr/              # Hyprland configuration
│   │   ├── conf.d/        # Modular configs
│   │   └── scripts/       # Hyprland scripts (power menu, etc.)
│   ├── waybar/            # Status bar config
│   ├── rofi/              # Application launcher
│   ├── mako/              # Notifications
│   ├── kitty/             # Terminal
│   ├── tmux/              # Terminal multiplexer
│   ├── wal/               # Pywal templates and hooks
│   └── systemd/user/      # User systemd services
├── scripts/               # Utility scripts
│   ├── set-wall           # Set wallpaper and theme
│   ├── reload-theme       # Reload theme
│   └── first-run.sh       # Initial setup
├── .zshrc                 # Zsh configuration
├── .bashrc                # Bash configuration
└── README.md              # This file
```

## Customization

### Adding Custom Keybindings

Edit `~/.config/hypr/conf.d/20-binds.conf`:

```
bind = $mod, KEY, action, params
```

### Changing Wallpaper Directory

Edit the wallpaper picker binding in `20-binds.conf` to point to your directory.

### Waybar Modules

Enable/disable modules in `~/.config/waybar/config.jsonc`:

```json
"modules-right": ["network", "pulseaudio", "cpu", "memory", "battery", "tray"]
```

### Screenshot Tools

The configuration supports both **grimblast** (recommended) and **grim + slurp** (fallback).

**Why grimblast?**
- Better Hyprland integration
- Easier syntax and usage
- Can capture active windows without geometry calculations
- Per-output screenshot support
- Built-in notification support

**Installation:**
```bash
# grimblast (AUR - recommended)
paru -S grimblast-git

# OR grim + slurp (official repos - fallback)
sudo pacman -S grim slurp

# Optional: screenshot editor
sudo pacman -S swappy
```

The screenshot script automatically detects which tool is available and uses grimblast if present.

## Troubleshooting

### Waybar not showing colors

Run manually to check for errors:
```bash
waybar
```

Ensure pywal template is generated:
```bash
ls ~/.cache/wal/waybar-wal.css
```

### Keybindings not working

Check if keybind is conflicting:
```bash
hyprctl binds
```

### Screen not locking

Test hyprlock manually:
```bash
hyprlock
```

Check hypridle service:
```bash
systemctl --user status hypridle
```

## Credits

- **Hyprland**: https://hyprland.org/
- **Pywal**: https://github.com/dylanaraps/pywal
- **Waybar**: https://github.com/Alexays/Waybar

## License

MIT License - Feel free to use and modify as needed.

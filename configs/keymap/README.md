# Keymap Configuration

This directory contains system-level keymap configurations that require manual installation with root privileges.

## Structure

```
keymap/
├── udev/          # udev hardware database files
│   └── *.hwdb     # Custom hardware mappings
└── keyd/          # keyd configuration files  
    └── default.conf   # Default key mapping configuration
```

## Installation

### udev Hardware Database Files

Copy `.hwdb` files to `/etc/udev/hwdb.d/`:

```bash
sudo cp configs/keymap/udev/*.hwdb /etc/udev/hwdb.d/
sudo systemd-hwdb update
sudo udevadm trigger
```

### keyd Configuration

Install keyd and copy configuration:

```bash
# Install keyd (Arch Linux)
sudo pacman -S keyd

# Copy configuration
sudo cp configs/keymap/keyd/default.conf /etc/keyd/

# Enable and start keyd service
sudo systemctl enable keyd
sudo systemctl start keyd
```

## Usage Notes

- **udev hwdb files**: Used for remapping hardware keys at the kernel level
- **keyd**: Modern key remapping daemon that works in Wayland and X11
- Both require root privileges for installation
- Changes take effect after service restart or system reboot

## Backup Your Current Configuration

Before applying these configurations, backup your existing files:

```bash
# Backup udev hwdb files
sudo cp /etc/udev/hwdb.d/*.hwdb ~/keymap-backup/ 2>/dev/null || true

# Backup keyd config
sudo cp /etc/keyd/default.conf ~/keymap-backup/ 2>/dev/null || true
```

## Why Manual Installation?

These configurations are excluded from the regular `./sync.sh` system because:
- They require root privileges to install
- They affect system-wide behavior
- They should be reviewed before installation
- Risk of breaking input if misconfigured
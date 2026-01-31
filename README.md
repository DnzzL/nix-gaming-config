# NixOS Gaming PC

A minimal NixOS configuration for a gaming desktop.

**Hardware:** Ryzen 5 2600 / GTX 1660 Super / MSI A320M A Pro Max

**What's included:**
- KDE Plasma 6 desktop with SDDM login screen
- Nvidia proprietary drivers
- Steam (with Proton support)
- Heroic Games Launcher (for Epic Games & GOG)
- Lutris + Wine (for Rockstar Games Launcher)
- Discord, Firefox
- GameMode, MangoHud, Gamescope

## Installation

### Step 1: Prepare the USB stick

Download the **Graphical ISO** from https://nixos.org/download and write it to a USB stick using `dd`:

```bash
# On macOS — find your USB drive name first
diskutil list
# Look for your USB (e.g. /dev/disk4), then:
diskutil unmountDisk /dev/disk4
sudo dd if=path/to/nixos.iso of=/dev/rdisk4 bs=4M status=progress
```

### Step 2: BIOS setup

1. Plug the USB stick into your gaming PC
2. Turn on the PC and press **Delete** repeatedly to enter the MSI BIOS
3. Go to **Settings > Security > Secure Boot** and set it to **Disabled**
4. Make sure **Boot Mode** is set to **UEFI**
5. Press **F10** to save and exit

### Step 3: Boot from USB

1. Restart the PC and press **F11** to open the boot menu
2. Select your USB stick
3. Ignore any `hv_balloon` / `hv_netvsc` errors — they are harmless on real hardware

### Step 4: Install NixOS

1. The graphical installer will start — follow the steps on screen
2. When asked about partitioning, choose your main drive and create:
   - An **EFI** partition (~512 MB)
   - A **swap** partition (8-16 GB, no hibernate)
   - A **root** partition (rest of the disk, ext4 or btrfs)
3. Set your username to **thomas** and pick a password
4. Finish the installer and reboot into your new NixOS system

### Step 5: Apply this configuration

After rebooting into NixOS, open a terminal (Konsole) and run:

```bash
# Set a password for your user if you haven't already
passwd

# Install git (temporarily, so you can clone this repo)
nix-shell -p git

# Clone this repo somewhere on your system
git clone <your-repo-url> ~/nix-config
cd ~/nix-config

# Copy the hardware config that the installer generated for YOUR machine
# (this file is unique to your hardware and disk layout)
cp /etc/nixos/hardware-configuration.nix ~/nix-config/

# Build and switch to this configuration
sudo nixos-rebuild switch --flake .#gaming-pc
```

Your system will rebuild with all the gaming software and Nvidia drivers. Reboot once more to make sure the Nvidia driver loads cleanly.

### Step 6: Set up game launchers

- **Steam** — Open Steam from the app menu. Go to **Settings > Compatibility** and enable **Steam Play for all titles** to use Proton.
- **Epic Games** — Open **Heroic Games Launcher** and sign into your Epic account.
- **Rockstar Launcher** — Open **Lutris**, click the **+** button, search for "Rockstar Games Launcher" in the Lutris database, and install it from there.
- **ProtonUp-Qt** — Use this to download extra Proton or Wine versions if a game needs a specific one.

## Making changes

Whenever you want to add or remove software, edit `configuration.nix` and rebuild:

```bash
sudo nixos-rebuild switch --flake .#gaming-pc
```

Your entire system is defined by these files — no hidden state.

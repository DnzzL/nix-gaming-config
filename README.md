# NixOS Gaming PC

A minimal NixOS configuration for a gaming desktop.

**Hardware:** Ryzen 5 2600 / GTX 1660 Super / MSI A320M A Pro Max

**What's included:**
- KDE Plasma 6 desktop with SDDM login screen
- Nvidia proprietary drivers
- Steam with Proton-GE pinned declaratively (no manual ProtonUp step)
- Heroic Games Launcher — Epic Games & GOG, incl. **GTA V** and the
  Rockstar-from-Epic wrapper (handled natively)
- Lutris + Wine — the **standalone Rockstar Games Launcher** (RDR2)
- Discord, Firefox
- GameMode, MangoHud, Gamescope, `vm.max_map_count` tuned for games

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

- **Steam** — Open Steam, go to **Settings > Compatibility**, enable
  **Steam Play for all titles**, and pick **GE-Proton** (already pinned
  by this config) as the default compatibility tool.

- **GTA V (Epic) via Heroic** — Open **Heroic**, sign into Epic, and
  install GTA V. The activation-code prompt is the Rockstar wrapper
  failing to verify Epic ownership; Heroic works around it:
  1. Use **Heroic 2.17+** (the fix is automated from that version).
  2. On the game's **Settings → Advanced → Environment Variables**, add
     `USE_FAKE_EPIC_EXE = true`.
  3. Set the Proton version to **GE-Proton9-27 or newer**. If the
     Rockstar Launcher won't open on GE-Proton **10-31/10-32**, fall
     back to **GE-Proton10-30**.
  4. If install is blocked on anticheat: General Settings → Advanced →
     enable *"Allow installation of games with broken or denied
     anticheat."*
  - Note: **story mode only** — GTA Online's BattleEye is not authorised
    on Linux and cannot be made to work.

- **RDR2 via the standalone Rockstar Games Launcher (Lutris)** — Open
  **Lutris**, **+ → Search Lutris website for installers**, find
  *Rockstar Games Launcher*, and run the community install script. In the
  runner options use a **wine-ge** build (download it in Lutris or via
  ProtonUp-Qt), then sign in and install RDR2. Single-player works;
  RDR Online is subject to the same anticheat limitation as GTA Online.

- **ProtonUp-Qt** — Manages GE-Proton/wine-ge runners for **Heroic and
  Lutris**. (Steam's Proton-GE is already provided by this config.)

## Making changes

Whenever you want to add or remove software, edit `configuration.nix` and rebuild:

```bash
sudo nixos-rebuild switch --flake .#gaming-pc
```

Your entire system is defined by these files — no hidden state.

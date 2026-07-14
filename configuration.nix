{ config, pkgs, ... }:

{
  # ── System ──────────────────────────────────────────────────────────
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +5"; # Keep last 5 generations
  };

  # ── Boot ────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ── Networking ──────────────────────────────────────────────────────
  networking.hostName = "gaming-pc";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # ── Locale & Time ───────────────────────────────────────────────────
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
  };

  # ── Keyboard ────────────────────────────────────────────────────────
  services.xserver.xkb.layout = "fr";
  console.keyMap = "fr";

  # ── Nvidia (GTX 1660 Super) ─────────────────────────────────────────
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # GTX 1660 Super uses proprietary driver
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # ── Bluetooth ────────────────────────────────────────────────────────
  hardware.bluetooth.enable = true;

  # ── CPU (Ryzen 5 2600) ──────────────────────────────────────────────
  hardware.cpu.amd.updateMicrocode = true;

  # ── Audio (PipeWire) ────────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ── Desktop (KDE Plasma 6) ──────────────────────────────────────────
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  xdg.portal.enable = true;


  # ── Gaming ──────────────────────────────────────────────────────────
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;   # "Gaming Mode" session at login
    remotePlay.openFirewall = true;

    # Declaratively pin Proton-GE into Steam's compatibility dropdown.
    # Reproducible — no manual ProtonUp-Qt step needed for Steam games.
    # (Heroic/Lutris manage their own runners; see ProtonUp-Qt below.)
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  programs.gamemode.enable = true; # Feral GameMode for performance

  # Gamescope micro-compositor with permission to renice itself for
  # smoother frame pacing (upscaling, framerate cap, HDR passthrough).
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # 32-bit support (required by many games)
  hardware.graphics.enable32Bit = true;

  # Many modern games (Rockstar titles especially) exhaust the default
  # mmap limit and crash on launch. Valve sets this on SteamOS by default.
  boot.kernel.sysctl."vm.max_map_count" = 2147483642;

  # ── Controllers ─────────────────────────────────────────────────────
  hardware.xone.enable = true;        # Xbox One/Series controller (wired)
  hardware.xpadneo.enable = true;     # Xbox controller Bluetooth support
  services.udev.packages = with pkgs; [
    game-devices-udev-rules           # udev rules for various controllers
  ];

  # ── User ────────────────────────────────────────────────────────────
  users.users.thomas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

  # ── Packages ────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Gaming launchers
    heroic                # Epic Games & GOG (runs GTA V + the Rockstar
                          # wrapper natively — see notes in README)
    lutris                # Standalone Rockstar Games Launcher (RDR2)
    protonup-qt           # Manage GE-Proton runners for Heroic & Lutris
    mangohud              # FPS / stats overlay

    # Wine (needed by Lutris to install the Rockstar Games Launcher).
    # DXVK is NOT installed system-wide — it's provided per-prefix by the
    # Proton / wine-ge runner, which is the only version that matters.
    wineWowPackages.staging
    winetricks
    protontricks          # winetricks for Steam/Proton prefixes

    # Cursor theme
    bibata-cursors

    # Apps
    discord
    firefox
    proton-pass
    ghostty

    # System utilities
    git
    htop
    vulkan-tools
    mesa-demos
  ];

  # ── Fonts (good defaults for gaming UIs) ────────────────────────────
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
  ];
}

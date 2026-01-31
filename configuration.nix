{ config, pkgs, ... }:

{
  # ── System ──────────────────────────────────────────────────────────
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ── Boot ────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ── Networking ──────────────────────────────────────────────────────
  networking.hostName = "gaming-pc";
  networking.networkmanager.enable = true;

  # ── Locale & Time ───────────────────────────────────────────────────
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

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

  # ── CPU (Ryzen 5 2600) ──────────────────────────────────────────────
  hardware.cpu.amd.updateMicrocode = true;

  # ── Audio (PipeWire) ────────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ── Desktop (KDE Plasma + SDDM) ────────────────────────────────────
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # ── Gaming ──────────────────────────────────────────────────────────
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;  # Optional: gamescope compositing
    remotePlay.openFirewall = true;
  };

  programs.gamemode.enable = true; # Feral GameMode for performance

  # 32-bit support (required by many games)
  hardware.graphics.enable32Bit = true;

  # ── User ────────────────────────────────────────────────────────────
  users.users.thomas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

  # ── Packages ────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Gaming
    heroic                # Epic Games & GOG launcher
    lutris                # Rockstar Launcher & other launchers
    protonup-qt           # Manage Proton/Wine versions
    mangohud              # FPS overlay
    gamescope             # Micro-compositor for games

    # Wine & DXVK (needed by Lutris for Rockstar Launcher)
    wineWowPackages.staging
    winetricks
    dxvk

    # Apps
    discord
    firefox

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

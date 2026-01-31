{ pkgs, ... }:

{
  home.stateVersion = "24.11";

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # ── Monitor ───────────────────────────────────────────────────────
      monitor = [ ", preferred, auto, 1" ];

      # ── Nvidia ────────────────────────────────────────────────────────
      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      # ── General ───────────────────────────────────────────────────────
      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgb(89b4fa)";
        "col.inactive_border" = "rgb(313244)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = false;
        };
      };

      animations.enabled = false; # Disable for max gaming performance

      input = {
        kb_layout = "fr";
        follow_mouse = 1;
        sensitivity = 0;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        vfr = true; # Variable refresh rate — saves GPU when idle
      };

      # ── Autostart ─────────────────────────────────────────────────────
      exec-once = [
        "waybar"
        "dunst"
        "nm-applet --indicator"
      ];

      # ── Keybinds ──────────────────────────────────────────────────────
      "$mod" = "SUPER";

      bind = [
        # Core
        "$mod, Return, exec, kitty"
        "$mod, D, exec, wofi --show drun"
        "$mod, Q, killactive"
        "$mod SHIFT, E, exit"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"
        "$mod, S, togglesplit"

        # App launchers
        "$mod, B, exec, firefox"
        "$mod, C, exec, discord"
        "$mod, G, exec, steam"
        "$mod, H, exec, heroic"
        "$mod, L, exec, lutris"
        "$mod, N, exec, proton-pass"

        # Focus (AZERTY-friendly: arrows)
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Move windows
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        # Workspaces (AZERTY: ampersand, eacute, quotedbl, apostrophe, etc.)
        "$mod, ampersand, workspace, 1"
        "$mod, eacute, workspace, 2"
        "$mod, quotedbl, workspace, 3"
        "$mod, apostrophe, workspace, 4"
        "$mod, parenleft, workspace, 5"
        "$mod, minus, workspace, 6"
        "$mod, egrave, workspace, 7"
        "$mod, underscore, workspace, 8"
        "$mod, ccedilla, workspace, 9"
        "$mod, agrave, workspace, 10"

        # Move window to workspace
        "$mod SHIFT, ampersand, movetoworkspace, 1"
        "$mod SHIFT, eacute, movetoworkspace, 2"
        "$mod SHIFT, quotedbl, movetoworkspace, 3"
        "$mod SHIFT, apostrophe, movetoworkspace, 4"
        "$mod SHIFT, parenleft, movetoworkspace, 5"
        "$mod SHIFT, minus, movetoworkspace, 6"
        "$mod SHIFT, egrave, movetoworkspace, 7"
        "$mod SHIFT, underscore, movetoworkspace, 8"
        "$mod SHIFT, ccedilla, movetoworkspace, 9"
        "$mod SHIFT, agrave, movetoworkspace, 10"

        # Screenshot
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SHIFT, Print, exec, grim - | wl-copy"

        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      # Mouse binds
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # ── Waybar ──────────────────────────────────────────────────────────
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "cpu" "memory" "tray" ];

      clock.format = "{:%H:%M  %a %d %b}";
      cpu.format = "CPU {usage}%";
      memory.format = "RAM {percentage}%";
      pulseaudio = {
        format = "VOL {volume}%";
        format-muted = "MUTE";
        on-click = "pavucontrol";
      };
      network = {
        format-wifi = "{essid}";
        format-disconnected = "offline";
      };
    };
    style = ''
      * {
        font-family: monospace;
        font-size: 13px;
      }
      window#waybar {
        background: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
      }
      #workspaces button {
        padding: 0 5px;
        color: #6c7086;
      }
      #workspaces button.active {
        color: #89b4fa;
      }
      #clock, #cpu, #memory, #pulseaudio, #network, #tray {
        padding: 0 10px;
      }
    '';
  };

  # ── Kitty terminal ──────────────────────────────────────────────────
  programs.kitty = {
    enable = true;
    settings = {
      font_size = 12;
      background_opacity = "0.9";
      confirm_os_window_close = 0;
    };
  };
}

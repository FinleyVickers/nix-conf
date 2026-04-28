{ lib, pkgs, ... }:

let
  catppuccin = {
    base = "#1e1e2e";
    mantle = "#181825";
    surface0 = "#313244";
    surface1 = "#45475a";
    text = "#cdd6f4";
    subtext1 = "#bac2de";
    lavender = "#b4befe";
    mauve = "#cba6f7";
    blue = "#89b4fa";
    green = "#a6e3a1";
    yellow = "#f9e2af";
    red = "#f38ba8";
  };
  wallpaper = "${pkgs.nixos-artwork.wallpapers.catppuccin-mocha}/share/backgrounds/nixos/nixos-wallpaper-catppuccin-mocha.png";
  codexConfigTemplate = pkgs.writeText "codex-config.toml" ''
    personality = "pragmatic"

    [projects."/home/finleyv"]
    trust_level = "trusted"

    [mcp_servers.nixos]
    command = "nix"
    args = ["run", "github:utensils/mcp-nixos", "--"]

    [mcp_servers.nixos.tools.nix]
    approval_mode = "approve"
  '';
  powerMenu = pkgs.writeShellScript "waybar-power-menu" ''
    choice="$(
      printf '%s\n' \
        "Lock" \
        "Logout" \
        "Suspend" \
        "Hibernate" \
        "Reboot" \
        "Shutdown" |
        ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt "Power: "
    )"

    case "$choice" in
      "Lock")
        ${pkgs.niri}/bin/niri msg action power-off-monitors
        ;;
      "Logout")
        ${pkgs.niri}/bin/niri msg action quit
        ;;
      "Suspend")
        ${pkgs.systemd}/bin/systemctl suspend
        ;;
      "Hibernate")
        ${pkgs.systemd}/bin/systemctl hibernate
        ;;
      "Reboot")
        ${pkgs.systemd}/bin/systemctl reboot
        ;;
      "Shutdown")
        ${pkgs.systemd}/bin/systemctl poweroff
        ;;
    esac
  '';
in
{
  home.username = "finleyv";
  home.homeDirectory = "/home/finleyv";

  home.shellAliases = {
    cflake = "cd ~/nixos-flake";
    hm = "home-manager switch --flake ~/nixos-flake#finleyv";
    ns = "sudo nixos-rebuild switch --flake ~/nixos-flake#nixos";
    nb = "sudo nixos-rebuild boot --flake ~/nixos-flake#nixos";
    nt = "sudo nixos-rebuild test --flake ~/nixos-flake#nixos";
    nfu = "nix flake update ~/nixos-flake";
  };

  home.packages = with pkgs; [
    brightnessctl
    discord
    fd
    fuzzel
    gamescope
    git
    grim
    heroic
    jq
    libnotify
    mangohud
    nautilus
    nerd-fonts.jetbrains-mono
    nodejs
    pavucontrol
    playerctl
    protonup-qt
    ripgrep
    slurp
    swaybg
    vesktop
    wl-clipboard
    wlogout
    xwayland-satellite
  ];

  # Codex updates this file itself when you change models interactively, so it
  # cannot live as an immutable Home Manager symlink in /nix/store.
  home.activation.codexWritableConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    target="$HOME/.codex/config.toml"

    mkdir -p "$HOME/.codex"

    if [ ! -e "$target" ] || [ -L "$target" ]; then
      rm -f "$target"
      cp ${codexConfigTemplate} "$target"
    fi
  '';

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    profiles.finleyv = {
      isDefault = true;
      settings = {
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "layout.css.prefers-color-scheme.content-override" = 0;
        "ui.systemUsesDarkTheme" = 1;
      };
    };
  };
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=11";
        pad = "12x12";
      };
      "colors-dark" = {
        alpha = "0.96";
        foreground = "cdd6f4";
        background = "1e1e2e";
        regular0 = "45475a";
        regular1 = "f38ba8";
        regular2 = "a6e3a1";
        regular3 = "f9e2af";
        regular4 = "89b4fa";
        regular5 = "cba6f7";
        regular6 = "94e2d5";
        regular7 = "bac2de";
        bright0 = "585b70";
        bright1 = "f38ba8";
        bright2 = "a6e3a1";
        bright3 = "f9e2af";
        bright4 = "89b4fa";
        bright5 = "cba6f7";
        bright6 = "94e2d5";
        bright7 = "a6adc8";
      };
    };
  };
  programs.home-manager.enable = true;
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        modules-left = [ "custom/nixos" "niri/workspaces" ];
        modules-center = [ "niri/window" "mpris" ];
        modules-right = [ "idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "battery" "tray" "clock" "custom/power" ];
        "custom/nixos" = {
          format = "󱄅";
          tooltip = true;
          tooltip-format = "NixOS";
        };
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };
        "niri/window" = {
          format = "{}";
          max-length = 64;
        };
        clock = {
          format = "{:%H:%M | %e %B}";
          tooltip-format = "{:%Y %B}\n{calendar}";
          format-alt = "{:%Y-%m-%d}";
        };
        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} {dynamic}";
          format-stopped = "";
          dynamic-order = [ "title" "artist" ];
          max-length = 48;
          player-icons = {
            default = "";
            firefox = "";
            spotify = "";
          };
          status-icons = {
            paused = "";
          };
          on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
          on-click-right = "${pkgs.playerctl}/bin/playerctl next";
          on-click-middle = "${pkgs.playerctl}/bin/playerctl previous";
          tooltip-format = "{player}: {title} - {artist}";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        cpu = {
          format = " {usage}%";
          tooltip = true;
        };
        memory = {
          format = " {}%";
          tooltip = true;
        };
        network = {
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = "{ipaddr}/{cidr} 󰈀";
          tooltip-format = "{ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP) 󰈀";
          format-disconnected = "Disconnected ";
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-bluetooth-muted = "󰝟 {icon} ";
          format-muted = "󰝟";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-full = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        "custom/power" = {
          format = "";
          tooltip = "Power menu";
          on-click = "${powerMenu}";
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
        transition: background-color .3s ease-out;
      }

      window#waybar {
        background: rgba(26, 27, 38, 0.75);
        color: #c0caf5;
        transition: background-color .5s;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        background: rgba(0, 0, 8, .7);
        margin: 3px 8px;
        padding: 0 4px;
        border-radius: 12px;
      }

      .modules-left {
        padding: 0;
      }

      .modules-center {
        padding: 0 8px;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray,
      #idle_inhibitor,
      #window,
      #mpris,
      #custom-power {
        padding: 0 10px;
        border-radius: 12px;
      }

      #clock:hover,
      #battery:hover,
      #cpu:hover,
      #memory:hover,
      #network:hover,
      #pulseaudio:hover,
      #tray:hover,
      #idle_inhibitor:hover,
      #window:hover,
      #mpris:hover,
      #custom-power:hover {
        background: rgba(26, 27, 38, 0.9);
      }

      #workspaces button {
        background: transparent;
        color: #c0caf5;
        border: none;
        border-radius: 12px;
        font-size: 14px;
        font-weight: 900;
        padding: 0 6px;
      }

      #workspaces button.active {
        background: #13131d;
        color: #c0caf5;
      }

      #workspaces button:hover {
        background: #11111b;
        color: #cdd6f4;
        box-shadow: none;
      }

      #custom-nixos {
        margin-left: 5px;
        padding: 0 8px;
        font-size: 19px;
        transition: color .5s;
      }

      #custom-nixos:hover {
        color: #1793d1;
      }

      #clock,
      #custom-power {
        color: #7dcfff;
      }

      #mpris {
        color: #9ece6a;
      }

      #battery.warning {
        color: #e0af68;
      }

      #battery.critical,
      #network.disconnected {
        color: #f7768e;
      }

      #idle_inhibitor.activated {
        color: #bb9af7;
      }

      #custom-power {
        font-size: 14px;
      }
    '';
  };
  programs.zsh = {
    enable = true;
    autocd = true;
    defaultKeymap = "emacs";
    enableCompletion = true;
    enableVteIntegration = true;

    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };

    history = {
      append = true;
      expireDuplicatesFirst = true;
      extended = true;
      findNoDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      save = 10000;
      share = true;
      size = 10000;
    };

    historySubstringSearch.enable = true;

    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "pattern" ];
    };

    completionInit = ''
      autoload -Uz compinit
      compinit
      zmodload zsh/complist
      _comp_options+=(globdots)
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*' squeeze-slashes true
      bindkey '^I' autosuggest-accept
    '';

    initContent = ''
      setopt AUTO_MENU
      setopt COMPLETE_IN_WORD
      setopt INTERACTIVE_COMMENTS
      setopt NO_FLOW_CONTROL

      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
    '';
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.theme = {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk;
    };
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Catppuccin-GTK-Dark";
      icon-theme = "Papirus-Dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  services.mako = {
    enable = true;
    settings = {
      background-color = "${catppuccin.base}F2";
      border-color = catppuccin.mauve;
      border-radius = 14;
      border-size = 2;
      default-timeout = 6000;
      font = "JetBrainsMono Nerd Font 10";
      height = 160;
      margin = "12";
      padding = "12";
      text-color = catppuccin.text;
      width = 380;
    };
  };

  xdg.configFile."niri/config.kdl".text = ''
    prefer-no-csd

    output "DP-3" {
      mode "1920x1080@119.982"
      scale 1
    }

    screenshot-path "~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png"

    hotkey-overlay {
      skip-at-startup
    }

    input {
      keyboard {
        xkb {
          layout "us"
        }
      }

      touchpad {
        tap
        natural-scroll
      }

      mouse {
        accel-speed 0.0
      }
    }

    layout {
      gaps 4
      center-focused-column "never"

      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }

      default-column-width {
        proportion 0.5
      }

      focus-ring {
        off
      }

      border {
        width 2
        active-color "${catppuccin.mauve}"
        inactive-color "${catppuccin.surface0}"
      }

      shadow {
        softness 30
        spread 5
        offset x=0 y=4
        color "#00000070"
      }
    }

    window-rule {
      geometry-corner-radius 14
      clip-to-geometry true
    }

    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    spawn-at-startup "swaybg" "-i" "${wallpaper}" "-m" "fill"

    binds {
      Super+Return { spawn "foot"; }
      Super+D { spawn "fuzzel"; }
      Super+B { spawn "firefox"; }
      Super+E { spawn "nautilus"; }
      Super+Slash { show-hotkey-overlay; }

      Super+Q { close-window; }
      Super+Shift+E { quit; }
      Super+Shift+P { power-off-monitors; }

      Super+Left  { focus-column-left; }
      Super+Down  { focus-window-down; }
      Super+Up    { focus-window-up; }
      Super+Right { focus-column-right; }
      Super+H     { focus-column-left; }
      Super+J     { focus-window-down; }
      Super+K     { focus-window-up; }
      Super+L     { focus-column-right; }

      Super+Shift+Left  { move-column-left; }
      Super+Shift+Down  { move-window-down; }
      Super+Shift+Up    { move-window-up; }
      Super+Shift+Right { move-column-right; }
      Super+Shift+H     { move-column-left; }
      Super+Shift+J     { move-window-down; }
      Super+Shift+K     { move-window-up; }
      Super+Shift+L     { move-column-right; }

      Super+Page_Down { focus-workspace-down; }
      Super+Page_Up   { focus-workspace-up; }
      Super+U         { focus-workspace-down; }
      Super+I         { focus-workspace-up; }

      Super+Ctrl+Page_Down { move-column-to-workspace-down; }
      Super+Ctrl+Page_Up   { move-column-to-workspace-up; }
      Super+Ctrl+U         { move-column-to-workspace-down; }
      Super+Ctrl+I         { move-column-to-workspace-up; }

      Super+Shift+Page_Down { move-workspace-down; }
      Super+Shift+Page_Up   { move-workspace-up; }
      Super+Shift+U         { move-workspace-down; }
      Super+Shift+I         { move-workspace-up; }

      Super+1 { focus-workspace 1; }
      Super+2 { focus-workspace 2; }
      Super+3 { focus-workspace 3; }
      Super+4 { focus-workspace 4; }
      Super+5 { focus-workspace 5; }
      Super+6 { focus-workspace 6; }
      Super+7 { focus-workspace 7; }
      Super+8 { focus-workspace 8; }
      Super+9 { focus-workspace 9; }

      Super+Ctrl+1 { move-column-to-workspace 1; }
      Super+Ctrl+2 { move-column-to-workspace 2; }
      Super+Ctrl+3 { move-column-to-workspace 3; }
      Super+Ctrl+4 { move-column-to-workspace 4; }
      Super+Ctrl+5 { move-column-to-workspace 5; }
      Super+Ctrl+6 { move-column-to-workspace 6; }
      Super+Ctrl+7 { move-column-to-workspace 7; }
      Super+Ctrl+8 { move-column-to-workspace 8; }
      Super+Ctrl+9 { move-column-to-workspace 9; }

      Super+Ctrl+Left  { focus-monitor-left; }
      Super+Ctrl+Down  { focus-monitor-down; }
      Super+Ctrl+Up    { focus-monitor-up; }
      Super+Ctrl+Right { focus-monitor-right; }

      Super+Shift+Ctrl+Left  { move-column-to-monitor-left; }
      Super+Shift+Ctrl+Down  { move-column-to-monitor-down; }
      Super+Shift+Ctrl+Up    { move-column-to-monitor-up; }
      Super+Shift+Ctrl+Right { move-column-to-monitor-right; }

      Super+R { switch-preset-column-width; }
      Super+F { maximize-column; }
      Super+Shift+F { fullscreen-window; }
      Super+C { center-column; }
      Super+Minus { set-column-width "-10%"; }
      Super+Equal { set-column-width "+10%"; }

      Print { screenshot; }
      Super+Print { screenshot-screen; }
      Super+Shift+S { spawn "sh" "-c" "mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"; }

      XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
      XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
      XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86MonBrightnessUp { spawn "brightnessctl" "set" "5%+"; }
      XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
    }
  '';

  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    font=JetBrainsMono Nerd Font:size=11
    width=42
    horizontal-pad=18
    vertical-pad=14
    inner-pad=10
    line-height=22

    [colors]
    background=1e1e2eee
    text=cdd6f4ff
    prompt=cba6f7ff
    placeholder=7f849cff
    input=cdd6f4ff
    match=f9e2afff
    selection=313244ff
    selection-text=cdd6f4ff
    selection-match=f9e2afff
    border=cba6f7ff

    [border]
    width=2
    radius=14
  '';

  xdg.configFile."wlogout/layout".text = ''
    [
      {
        "label": "logout",
        "action": "${pkgs.niri}/bin/niri msg action quit",
        "text": "Logout",
        "keybind": "e"
      },
      {
        "label": "suspend",
        "action": "${pkgs.systemd}/bin/systemctl suspend",
        "text": "Suspend",
        "keybind": "s"
      },
      {
        "label": "hibernate",
        "action": "${pkgs.systemd}/bin/systemctl hibernate",
        "text": "Hibernate",
        "keybind": "h"
      },
      {
        "label": "reboot",
        "action": "${pkgs.systemd}/bin/systemctl reboot",
        "text": "Reboot",
        "keybind": "r"
      },
      {
        "label": "shutdown",
        "action": "${pkgs.systemd}/bin/systemctl poweroff",
        "text": "Shutdown",
        "keybind": "p"
      }
    ]
  '';

  xdg.configFile."wlogout/style.css".text = ''
    * {
      border: none;
      border-radius: 0;
      font-family: "JetBrainsMono Nerd Font";
      font-size: 15px;
    }

    window {
      background: alpha(${catppuccin.mantle}, 0.72);
    }

    button {
      background: alpha(${catppuccin.base}, 0.96);
      border: 1px solid ${catppuccin.surface0};
      border-radius: 14px;
      color: ${catppuccin.text};
      margin: 10px;
      padding: 18px;
    }

    button:focus,
    button:hover {
      background: ${catppuccin.surface0};
      border-color: ${catppuccin.mauve};
      color: ${catppuccin.lavender};
    }

    #hibernate {
      border-color: ${catppuccin.blue};
    }

    #shutdown {
      border-color: ${catppuccin.red};
    }
  '';

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  home.stateVersion = "25.11";
}

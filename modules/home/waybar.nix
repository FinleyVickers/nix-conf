{ pkgs, powerMenu }:

{
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
}


{ pkgs, catppuccin, wallpaper }:

{
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
}

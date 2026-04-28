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
  imports = [
    (import ./modules/home/programs.nix { inherit lib pkgs codexConfigTemplate; })
    (import ./modules/home/waybar.nix { inherit pkgs powerMenu; })
    (import ./modules/home/desktop.nix { inherit pkgs catppuccin; })
    (import ./modules/home/niri.nix { inherit pkgs catppuccin wallpaper; })
  ];

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

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  home.stateVersion = "25.11";
}

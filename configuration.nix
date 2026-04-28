{ pkgs, codexPackageFor, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/hardware.nix
    ./modules/gaming.nix
    ./modules/networking.nix
    ./modules/services.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.zsh.enable = true;

  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_CA.UTF-8";

  users.users.finleyv = {
    isNormalUser = true;
    description = "Finley Vickers";
    extraGroups = [ "gamemode" "networkmanager" "video" "wheel" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    (codexPackageFor pkgs.stdenv.hostPlatform.system)
    pkgs.home-manager
  ];

  system.stateVersion = "25.11";
}

{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    extest.enable = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extraPackages = with pkgs; [
      gamescope
      mangohud
    ];
  };

  environment.systemPackages = with pkgs; [
    heroic
    mangohud
    prismlauncher
    protonup-qt
    winetricks
    wineWow64Packages.staging
  ];
}

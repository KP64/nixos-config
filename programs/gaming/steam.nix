{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.gaming.steam.enable = lib.mkEnableOption "Enables steam";

  config = lib.mkIf config.gaming.steam.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
  };
}

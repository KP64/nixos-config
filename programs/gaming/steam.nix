{
  pkgs,
  lib,
  config,
  username,
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
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    environment.persistence."/persist".users.${username}.directories = [ 
      ".steam"
      ".local/share/Steam"
    ];
  };
}

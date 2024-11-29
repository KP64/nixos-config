{
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.gaming.steam;
in
{
  options.gaming.steam.enable = lib.mkEnableOption "Steam";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
    })

    (lib.mkIf config.system.impermanence.enable {
      environment.persistence."/persist".users.${username}.directories = lib.optionals cfg.enable [
        ".steam"
        ".local/share/Steam"
      ];
    })
  ];
}

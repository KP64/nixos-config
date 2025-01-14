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
    {
      programs.steam = {
        inherit (cfg) enable;
        extest.enable = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;
        extraCompatPackages = with pkgs; [ proton-ge-bin ];
      };
    }

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories = lib.optionals cfg.enable [
        ".steam"
        ".local/share/Steam"
      ];
    })
  ];
}

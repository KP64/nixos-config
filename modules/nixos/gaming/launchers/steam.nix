{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gaming.launchers.steam;
in
{
  options.gaming.launchers.steam.enable = lib.mkEnableOption "Steam";

  config.programs.steam = {
    inherit (cfg) enable;
    extest.enable = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };
}

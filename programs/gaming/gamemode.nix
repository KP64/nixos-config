{ lib, config, ... }:
let
  cfg = config.gaming.gamemode;
in
{
  options.gaming.gamemode.enable = lib.mkEnableOption "Gamemode";

  config.programs.gamemode = { inherit (cfg) enable; };
}

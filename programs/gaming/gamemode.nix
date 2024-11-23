{ lib, config, ... }:
{
  options.gaming.gamemode.enable = lib.mkEnableOption "Gamemode";

  config = lib.mkIf config.gaming.gamemode.enable { programs.gamemode.enable = true; };
}

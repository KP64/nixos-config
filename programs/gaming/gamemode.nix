{ lib, config, ... }:
{
  options.gaming.gamemode.enable = lib.mkEnableOption "Enables Gamemode";

  config = lib.mkIf config.gaming.gamemode.enable { programs.gamemode.enable = true; };
}

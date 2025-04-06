{ config, lib, ... }:
let
  cfg = config.cli.starship;
in
{
  options.cli.starship.enable = lib.mkEnableOption "Starship";

  config.programs.starship = {
    inherit (cfg) enable;
    settings = lib.importTOML ./preset.toml;
  };
}

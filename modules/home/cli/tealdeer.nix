{ config, lib, ... }:
let
  cfg = config.cli.tealdeer;
in
{
  options.cli.tealdeer.enable = lib.mkEnableOption "Tealdeer";

  config.programs.tealdeer = {
    inherit (cfg) enable;
    settings = {
      updates.auto_update = true;
      display.use_pager = true;
    };
  };
}

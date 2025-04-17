{ config, lib, ... }:
let
  cfg = config.cli.multiplexer.zellij;
in
{
  options.cli.multiplexer.zellij.enable = lib.mkEnableOption "Zellij";

  config.programs.zellij = {
    inherit (cfg) enable;
    settings.show_startup_tips = false;
  };
}

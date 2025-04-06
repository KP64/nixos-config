{ config, lib, ... }:
let
  cfg = config.cli.zoxide;
in
{
  options.cli.zoxide.enable = lib.mkEnableOption "Zoxide";

  config.programs.zoxide = {
    inherit (cfg) enable;
    options = [ "--cmd cd" ];
  };
}

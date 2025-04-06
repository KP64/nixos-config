{ config, lib, ... }:
let
  cfg = config.cli.fd;
in
{
  options.cli.fd.enable = lib.mkEnableOption "fd";

  config.programs.fd = {
    inherit (cfg) enable;
    hidden = true;
  };
}

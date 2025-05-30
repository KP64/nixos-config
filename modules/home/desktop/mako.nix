{ config, lib, ... }:
let
  cfg = config.desktop.services.mako;
in
{
  options.desktop.services.mako.enable = lib.mkEnableOption "Mako";

  config.services.mako = {
    inherit (cfg) enable;
    settings.defaultTimeout = 4000;
  };
}

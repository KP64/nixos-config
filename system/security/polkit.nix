{ lib, config, ... }:
let
  cfg = config.system.security.polkit;
in
{
  options.system.security.polkit.enable = lib.mkEnableOption "polkit";

  config.security.polkit = { inherit (cfg) enable; };
}

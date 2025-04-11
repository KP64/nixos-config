{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.desktop.hyprsunset;
in
{
  options.desktop.hyprsunset.enable = lib.mkEnableOption "Hyprsunset";

  config.services.hyprsunset = {
    inherit (cfg) enable;
    package = inputs.hyprsunset.packages.${pkgs.system}.hyprsunset;
    extraArgs = [ "--identity" ];
  };
}

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

  # FIX: Broken in home-manager itself
  config.services.hyprsunset = {
    inherit (cfg) enable;
    package = inputs.hyprsunset.packages.${pkgs.system}.hyprsunset;
    extraArgs = [ "--identity" ];
    # TODO: Do some Profiles :)
    settings = { };
  };
}

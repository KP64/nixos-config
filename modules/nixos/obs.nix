{ config, lib, ... }:
let
  cfg = config.apps.obs;
in
{
  options.apps.obs.enable = lib.mkEnableOption "OBS";

  config.programs.obs-studio = {
    inherit (cfg) enable;
    enableVirtualCamera = true;
  };
}

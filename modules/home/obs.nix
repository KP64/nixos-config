{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.apps.obs;
in
{
  options.apps.obs.enable = lib.mkEnableOption "OBS";

  config.programs.obs-studio = {
    inherit (cfg) enable;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vaapi
      obs-vkcapture
      obs-pipewire-audio-capture
    ];
  };
}

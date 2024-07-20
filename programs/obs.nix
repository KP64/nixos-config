{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:
{
  options.apps.obs.enable = lib.mkEnableOption "Enables OBS";

  config = lib.mkIf config.apps.obs.enable {
    boot = {
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      kernelModules = [ "v4l2loopback" ];
      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
    };

    home-manager.users.${username} = {
      xdg.configFile."obs-studio/themes" = {
        source = inputs.obs-catppuccin + "/themes/";
        recursive = true;
      };

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-vaapi
          obs-vkcapture
          obs-pipewire-audio-capture
        ];
      };
    };
  };
}

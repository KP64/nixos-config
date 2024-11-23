{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.apps.obs.enable = lib.mkEnableOption "OBS";

  config = lib.mkIf config.apps.obs.enable {
    boot = {
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      kernelModules = [ "v4l2loopback" ];
      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
    };

    home-manager.users.${username}.programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vaapi
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
    environment.persistence."/persist".users.${username}.directories = [
      ".config/obs-studio"
    ];
  };
}

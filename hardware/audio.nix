{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  imports = [ inputs.musnix.nixosModules.musnix ];

  options.hardware.audio.enable = lib.mkEnableOption "Audio";

  config = lib.mkIf config.hardware.audio.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    musnix = {
      enable = true;
      rtcqs.enable = true;
    };

    environment.systemPackages = [ pkgs.pavucontrol ];
  };
}

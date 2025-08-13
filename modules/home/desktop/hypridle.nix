{ config, lib, ... }:
let
  dispatch_dpms = cmd: "hyprctl dispatch dpms ${cmd}";
  minutes = mins: 60 * mins;
  cfg = config.desktop.hypridle;
in
{
  options.desktop.hypridle.enable = lib.mkEnableOption "Hypridle";

  config.services.hypridle = {
    inherit (cfg) enable;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = dispatch_dpms "on";
      };

      listener = [
        {
          timeout = minutes 5;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = minutes 30;
          on-timeout = dispatch_dpms "off";
          on-resume = dispatch_dpms "on";
        }
        {
          timeout = minutes 60;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}

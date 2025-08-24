{ pkgs, ... }:
let
  dispatch_dpms = cmd: "hyprctl dispatch dpms ${cmd}";
  minutes = mins: 60 * mins;
in
{
  home.packages = [ pkgs.brightnessctl ];

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = dispatch_dpms "on";
      };

      listener = [
        {
          timeout = minutes 2.5;
          # set monitor backlight to minimum, avoid 0 on OLED monitor
          on-timeout = "brightnessctl -s set 10";
          # monitor backlight restore
          on-resume = "brightnessctl -r";
        }
        {
          timeout = minutes 2.5;
          # turn off keyboard backlight
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
          # turn on keyboard backlight
          on-resume = "brightnessctl -rd rgb:kbd_backlight";
        }
        {
          timeout = minutes 5;
          # lock screen when timeout has passed
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = minutes 15;
          # screen off when timeout has passed
          on-timeout = dispatch_dpms "off";
          # screen on when activity is detected after timeout has fired.
          on-resume = "${dispatch_dpms "on"} && brightnessctl -r";
        }
        {
          timeout = minutes 60;
          # suspend pc
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}

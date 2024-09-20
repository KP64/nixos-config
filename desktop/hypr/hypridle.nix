{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:
let
 dispatch_dpms = cmd: "hyprctl dispatch dpms ${cmd}";
in
{
  options.desktop.hypr.hypridle.enable = lib.mkEnableOption "Enables Hypridle";

  config = lib.mkIf config.desktop.hypr.hypridle.enable {
    home-manager.users.${username}.services.hypridle = {
      enable = true;
      package = inputs.hypridle.packages.${pkgs.system}.hypridle;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = dispatch_dpms "on";
        };

        listener = [
          {
            timeout = 300; # 5 min
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 1800; # 30 min
            on-timeout = dispatch_dpms "off";
            on-resume = dispatch_dpms "on";
          }
          {
            timeout = 3600; # 1 h
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}

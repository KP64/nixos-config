let
  dispatch_dpms = cmd: "hyprctl dispatch dpms ${cmd}";
  lock_session = "loginctl lock-session";
  minutes = mins: 60 * mins;
in
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = lock_session;
        after_sleep_cmd = dispatch_dpms "on";
      };

      listener = [
        {
          timeout = minutes 5;
          on-timeout = lock_session;
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

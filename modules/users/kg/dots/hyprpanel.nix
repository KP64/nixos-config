{
  flake.modules.homeManager.users-kg = {
    programs.hyprpanel = {
      enable = true;
      settings.bar.layouts."*" = {
        left = [
          "dashboard"
          "battery"
          "volume"
        ];
        middle = [ "clock" ];
        right = [
          "network"
          "bluetooth"
          "notifications"
        ];
      };
    };
  };
}

{
  flake.modules.homeManager.users-kg = {
    programs.hyprpanel = {
      enable = true;
      settings.bar.layouts."*" = {
        left = [
          "dashboard"
          "clock"
        ];
        middle = [ "media" ];
        right = [
          "network"
          "volume"
          "bluetooth"
          "battery"
          "notifications"
        ];
      };
    };
  };
}

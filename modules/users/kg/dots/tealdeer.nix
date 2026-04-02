{
  flake.modules.homeManager.users-kg-tealdeer = {
    programs.tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = true;
          show_title = true;
        };
        updates = {
          auto_update = true;
          auto_update_interval_hours = 24;
          tls_backend = "rustls-with-native-roots";
        };
      };
    };
  };
}

{
  den.aspects.kg._.tealdeer.homeManager = {
    programs.tealdeer = {
      enable = true;
      settings.updates = {
        auto_update = true;
        auto_update_interval_hours = 24;
        tls_backend = "rustls-with-native-roots";
      };
    };
  };
}

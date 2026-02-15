{
  flake.aspects.users-kg-glance.homeManager = {
    services.glance = {
      enable = true;
      settings = {
        # Not necessary but nice for firefox
        server.port = 8080;

        branding = {
          hide-footer = true;
          logo-text = "K";
        };
        theme = {
          background-color = "240 21 15";
          contrast-multiplier = 1.2;
          primary-color = "217 92 83";
          positive-color = "115 54 76";
          negative-color = "347 70 65";
        };
      };
    };
  };
}

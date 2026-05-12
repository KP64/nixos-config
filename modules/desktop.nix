{
  den.aspects.desktop = {
    nixos =
      { config, lib, ... }:
      let
        inherit (config.lib.hm) anyHmUser;
      in
      {
        services.displayManager.sddm = {
          enable = true;
          wayland.enable = true;
        };

        environment.pathsToLink =
          let
            portalActivated = anyHmUser (hmUserCfg: hmUserCfg.xdg.portal.enable);
          in
          lib.optionals (config.home-manager.useUserPackages && portalActivated) (
            map (d: "/share/${d}") [
              "applications"
              "xdg-desktop-portal"
            ]
          );

        programs.niri.enable = anyHmUser (hmUserCfg: hmUserCfg.programs.niri.enable or false);

        qt.enable = true;
      };

    homeManager = {
      gtk.enable = true;
      qt.enable = true;

      xdg = {
        enable = true;
        autostart.enable = true;
        mime.enable = true;
        mimeApps.enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
        };
      };
    };
  };
}

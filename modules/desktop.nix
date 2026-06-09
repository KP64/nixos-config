{
  den.aspects.desktop = {
    nixos = { config, lib, ... }: {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      environment.pathsToLink =
        let
          portalActivated = config.lib.hm.anyHmUser (hmUserCfg: hmUserCfg.xdg.portal.enable);
        in
        lib.optionals (config.home-manager.useUserPackages && portalActivated) (
          map (d: "/share/${d}") [
            "applications"
            "xdg-desktop-portal"
          ]
        );

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

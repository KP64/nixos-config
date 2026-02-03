toplevel: {
  flake.modules = {
    nixos.desktop =
      { config, lib, ... }:
      {
        config = lib.mkMerge [
          {
            services.displayManager.sddm = {
              enable = true;
              wayland.enable = true;
            };

            programs =
              let
                anyHmUser = cond: config.home-manager.users |> builtins.attrValues |> builtins.any cond;
              in
              {
                hyprland.enable = anyHmUser (hmUserCfg: hmUserCfg.wayland.windowManager.hyprland.enable);
                niri.enable = anyHmUser (hmUserCfg: hmUserCfg.programs.niri.enable or false);
              };

            qt.enable = true;

            home-manager.sharedModules = [
              toplevel.config.flake.modules.homeManager.desktop
              {
                wayland.windowManager.hyprland = {
                  package = null;
                  portalPackage = null;
                };
              }
            ];
          }
          (lib.mkIf config.hardware.bluetooth.enable {
            services.blueman.enable = true;
            home-manager.sharedModules = [ { services.blueman-applet.enable = true; } ];
          })
        ];
      };

    homeManager.desktop = {
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

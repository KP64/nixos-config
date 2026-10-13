toplevel@{ den, ... }:
{
  den = {
    schema.host = { config, ... }: {
      options.isDesktop = toplevel.lib.mkOption {
        type = toplevel.lib.types.bool;
        default = config.isUsedInteractively && config.isGraphical && !config.isServer;
        example = true;
        description = "Whether the machine is a Desktop";
      };
    };
    default.includes = [ den.aspects.desktop ];
    aspects.desktop =
      { host, lib, ... }:
      lib.optionalAttrs host.isDesktop {
        nixos = { config, lib, ... }: {
          services.displayManager.sddm = {
            enable = true;
            wayland.enable = true;
          };

          fonts.fontconfig.enable = true;

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

          home.pointerCursor.enable = true;

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
  };
}

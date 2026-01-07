toplevel@{ moduleWithSystem, ... }:
{
  flake.modules = {
    nixos.desktop = moduleWithSystem (
      { inputs', ... }:
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
                niri = {
                  enable = anyHmUser (hmUserCfg: hmUserCfg.programs.niri.enable or false);
                  package = inputs'.niri-flake.packages.niri-unstable;
                };
              };

            qt.enable = true;

            home-manager.sharedModules =
              let
                inherit (toplevel.config.flake.modules) homeManager;
              in
              [ homeManager.desktop ]
              ++ [
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
      }
    );

    homeManager.desktop =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (config.lib) nixGL;
      in
      {
        config = {
          # NOTE: When HM warnings are triggered they won't
          #       show when used as a NixOS module
          warnings = lib.optional (config.wayland.windowManager.hyprland.portalPackage != null) ''
            This will most likely NOT work at all!
            Set the hyprland portalPackage to null and install it via your favourite package manager!
          '';

          wayland.windowManager.hyprland.package = lib.mkDefault <| nixGL.wrap <| pkgs.hyprland;

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
  };
}

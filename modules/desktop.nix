toplevel: {
  flake.modules = {
    nixos.desktop =
      { config, lib, ... }:
      {
        services.displayManager.sddm = {
          enable = true;
          wayland.enable = true;
        };

        programs.hyprland.enable = true;

        # Is only installed if nvidia is supported by the system
        hardware.nvidia.nvidiaSettings = true;

        home-manager.sharedModules =
          let
            inherit (toplevel.config.flake.modules) homeManager;
          in
          [ homeManager.desktop ]
          ++ lib.optional config.services.blueman.enable homeManager.bluetooth
          ++ [
            {
              wayland.windowManager.hyprland = {
                package = null;
                portalPackage = null;
              };
            }
          ];
      };

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
        imports = [ toplevel.config.flake.modules.homeManager.wrap-graphics ];

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

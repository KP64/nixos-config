toplevel:
{
  flake.modules = { nixos.desktop = {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    # Is only installed if nvidia is supported by the system
    hardware.nvidia.nvidiaSettings = true;

    home-manager.sharedModules = [ toplevel.config.flake.modules.homeManager.desktop ];
  };

  homeManager.desktop =
    { config, ... }:
    {
      xdg.configFile."uwsm/env".source =
        "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

      wayland.windowManager.hyprland = {
        package = null;
        portalPackage = null;
        systemd.enable = false;
      };

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

{
  # TODO: Move stuff to Desktop
  flake.modules.nixos.hyprland = {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    home-manager.sharedModules = [
      (
        { config, ... }:
        {
          xdg.configFile."uwsm/env".source =
            "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

          wayland.windowManager.hyprland = {
            package = null;
            portalPackage = null;
            systemd.enable = false;
          };
        }
      )
      {
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
      }
    ];
  };
}

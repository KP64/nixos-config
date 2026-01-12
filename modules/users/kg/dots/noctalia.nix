{ self, inputs, ... }:
{
  flake.modules.homeManager.users-kg-noctalia-shell =
    { config, lib, ... }:
    let
      invisible = import (inputs.nix-invisible + /users/${config.home.username}.nix);
    in
    {
      imports = [ inputs.noctalia.homeModules.default ];

      # TODO: Replace with custom Quickshell config
      programs.noctalia-shell = {
        enable = true;
        systemd.enable = true;
        colors = {
          mError = "#f38ba8"; # red
          mOnError = "#1e1e2e"; # base

          mPrimary = "#b4befe"; # lavender
          mOnPrimary = "#1e1e2e"; # base

          mSecondary = "#89b4fa"; # blue
          mOnSecondary = "#1e1e2e"; # base

          mTertiary = "#f5c2e7"; # pink
          mOnTertiary = "#1e1e2e"; # base

          mSurface = "#1e1e2e"; # base
          mOnSurface = "#cdd6f4"; # text

          mSurfaceVariant = "#313244"; # surface0
          mOnSurfaceVariant = "#bac2de"; # subtext1

          mHover = "#45475a"; # surface1
          mOnHover = "#f5e0dc"; # rosewater

          mOutline = "#585b70"; # surface2
          mShadow = "#11111b"; # mantle
        };
        settings = {
          general.avatarImage = builtins.path {
            path = self + /modules/users/${config.home.username}/pfp.jpg;
          };
          uifontDefault = "JetBrainsMono Nerd Font";
          location = {
            name = invisible.location;
            showWeekNumberInCalendar = false;
          };
          wallpaper = {
            overviewEnabled = true;
            directory = builtins.path { path = self + /assets/wallpapers/catppuccin; };
          };
          appLauncher.enableClipboardHistory = true;
          systemMonitor = {
            useCustomColors = true;
            warningColor = "#fab387";
            criticalColor = "#f38ba8";
          };
          dock.colorizeIcons = true;
          bar.widgets = {
            left = [
              { id = "Launcher"; }
              {
                id = "Clock";
                useMonospacedFont = true;
              }
              { id = "SystemMonitor"; }
              { id = "MediaMini"; }
            ];
            center = lib.singleton {
              hideUnoccupied = true;
              id = "Workspace";
              labelMode = "none";
            };
          };
        };
      };

    };
}

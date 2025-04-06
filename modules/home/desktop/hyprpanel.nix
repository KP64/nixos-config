{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.desktop.hyprpanel;
in
{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

  options.desktop.hyprpanel.enable = lib.mkEnableOption "Hyprpanel";

  config.programs.hyprpanel = {
    inherit (cfg) enable;
    hyprland.enable = true;
    overwrite.enable = true;
    # TODO: Configurable
    theme = "catppuccin_mocha";

    layout."bar.layouts"."*" = {
      left = [
        "dashboard"
        "workspaces"
      ];
      middle = [ "media" ];
      right = [
        "network"
        "battery"
        "volume"
        "bluetooth"
        "systray"
        "clock"
        "hyprsunset"
        "notifications"
      ];
    };

    settings = {
      wallpaper.enable = false;

      bar = {
        clock.format = "%a %x %X";
        media.show_active_only = true;
        windowtitle.label = false;
        launcher.icon = "";
        workspaces = {
          show_numbered = true;
          workspaces = config.maxWorkspaceCount;
        };
      };

      menus = {
        clock.weather = {
          # inherit (invisible.weatherApi) location;
          # key = config.sops.secrets."weather.json".path;
          unit = "metric";
        };

        dashboard = {
          shortcuts.left = {
            shortcut1 = {
              icon = "";
              command = "firefox";
              tooltip = "Firefox";
            };
            shortcut2.command = "spotify";
            shortcut3.command = "vesktop";
          };

          directories = {
            left = {
              directory1.command = "thunar Downloads";
              directory2.command = "thunar Videos";
              directory3 = {
                command = "thunar Desktop";
                label = "󰚝 Desktop";
              };
            };
            right = {
              directory1.command = "thunar Documents";
              directory2.command = "thunar Pictures";
              directory3.command = "thunar";
            };
          };
        };
      };
    };
  };
}

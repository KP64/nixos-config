{
  config,
  lib,
  invisible,
  ...
}:
let
  cfg = config.desktop.hyprpanel;
in
{
  options.desktop.hyprpanel.enable = lib.mkEnableOption "Hyprpanel";

  config.programs.hyprpanel = {
    inherit (cfg) enable;

    settings = {
      wallpaper.enable = false;

      theme.name = "catppuccin_mocha";

      bar = {
        layouts."*" = {
          left = [
            "dashboard"
            "workspaces"
          ];
          middle = [ "clock" ];
          right = [
            "battery"
            "volume"
            "bluetooth"
            "systray"
            "hyprsunset"
            "notifications"
          ];
        };
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
        clock.weather =
          let
            inherit (config.sops) secrets;
          in
          {
            inherit (invisible.users.${config.home.username}.weatherApi) location;
            unit = "metric";
          }
          // lib.optionalAttrs (secrets ? "weather.json") { key = secrets."weather.json".path; };

        dashboard = {
          shortcuts.left = {
            shortcut1 = {
              icon = "";
              command = "firefox";
              tooltip = "Firefox";
            };
            shortcut2.command = "spotify";
            shortcut3.command = "discord";
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

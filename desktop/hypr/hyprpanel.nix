{
  config,
  lib,
  inputs,
  invisible,
  username,
  ...
}:
let
  cfg = config.desktop.hypr.hyprpanel;

  inherit (config.lib.stylix) colors;

  accent = "#${colors.base0D}";
  accent-alt = "#${colors.base03}";
  background = "#${colors.base00}";
  background-alt = "#${colors.base01}";
  foreground = "#${colors.base05}";
in
{
  options.desktop.hypr.hyprpanel.enable = lib.mkEnableOption "Hyprpanel";

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.hyprpanel.overlay ];

    home-manager.users.${username} = {
      imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

      programs.hyprpanel = {
        enable = true;
        hyprland.enable = true;
        overwrite.enable = true;
        theme = lib.optionalString config.isCatppuccinEnabled "catppuccin_mocha";

        layout."bar.layouts"."*" = {
          left = [
            "dashboard"
            "workspaces"
          ];
          middle = [ "media" ];
          right = [
            "network"
            "volume"
            "bluetooth"
            "systray"
            "clock"
            "hyprsunset"
            "notifications"
          ];
        };

        override = lib.optionalAttrs config.isStylixEnabled {
          theme = {
            bar = {
              buttons = {
                style = "default";
                monochrome = true;
                text = foreground;
                icon = accent;
                hover = background;
                workspaces = {
                  hover = accent-alt;
                  active = accent;
                  available = accent-alt;
                  occupied = accent;
                };
                notifications = {
                  background = background-alt;
                  hover = background;
                  total = accent;
                  icon = accent;
                };
              };
              menus = {
                inherit background;
                cards = background-alt;
                label = foreground;
                text = foreground;
                border.color = accent;
                popover = {
                  text = foreground;
                  background = background-alt;
                };
                iconbuttons.active = accent;
                progressbar.foreground = accent;
                slider.primary = accent;
                listitems.active = accent;
                icons.active = accent;
                switch.enabled = accent;
                check_radio_button.active = accent;
                buttons = {
                  default = accent;
                  active = accent;
                };
                tooltip = {
                  background = background-alt;
                  text = foreground;
                };
                dropdownmenu = {
                  background = background-alt;
                  text = foreground;
                };
                menu.media = {
                  background.color = background-alt;
                  card.color = background-alt;
                };
              };
            };
            notification = {
              background = background-alt;
              actions = {
                background = accent;
                text = foreground;
              };
              label = accent;
              border = background-alt;
              text = foreground;
              labelicon = accent;
            };
            osd = {
              bar_color = accent;
              bar_overflow_color = accent-alt;
              icon = background;
              icon_container = accent;
              label = accent;
              bar_container = background-alt;
            };
          };
        };

        settings =
          let
            stylixOnly.theme.bar = {
              transparent = true;
              menus.monochrome = true;
            };
          in
          (lib.optionalAttrs config.isStylixEnabled stylixOnly)
          // {
            wallpaper.enable = false;

            bar = {
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
                inherit (invisible.weatherApi) location;
                key = config.sops.secrets."weather.json".path;
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
    };
  };
}

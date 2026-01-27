{ moduleWithSystem, inputs, ... }:
{
  flake.modules.homeManager.users-kg-niri = moduleWithSystem (
    { inputs', ... }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (inputs'.niri-flake.packages) niri-unstable xwayland-satellite-unstable;
    in
    {
      imports = [ inputs.niri-flake.homeModules.niri ];

      services.playerctld.enable = true;

      home.packages = with pkgs; [
        brightnessctl
        wl-clipboard
      ];

      programs.niri = {
        enable = true;
        package = niri-unstable;
        settings = {
          xwayland-satellite.path = lib.getExe xwayland-satellite-unstable;
          prefer-no-csd = true;
          environment.ELECTRON_OZONE_PLATFORM_HINT = "auto";
          clipboard.disable-primary = true; # Disable middle click paste
          gestures.hot-corners.enable = false;
          hotkey-overlay.skip-at-startup = true;
          overview = {
            backdrop-color = "#11111b";
            workspace-shadow.enable = false;
          };
          layout = {
            always-center-single-column = true;
            gaps = 8;
            border = {
              enable = true;
              width = 2;
              active.color = "#9399b2"; # Catppuccin Mocha Overlay 2
              inactive.color = "#11111b"; # Catppuccin Mocha Crust
              urgent.color = "#74c7ec"; # Catppuccin Mocha Sapphire
            };
            focus-ring.enable = false;
            preset-column-widths = [
              { proportion = 1.0 / 4.0; }
              { proportion = 1.0 / 3.0; }
              { proportion = 1.0 / 2.0; }
              { proportion = 2.0 / 3.0; }
              { proportion = 5.0 / 6.0; }
            ];
            default-column-width.proportion = 1.0 / 3.0;
          };
          input = {
            keyboard.xkb = {
              layout = "de";
              options = "caps:escape";
            };
            mouse.scroll-button-lock = true;
          };
          cursor = {
            hide-after-inactive-ms = 1000;
            size = 32;
          };
          outputs =
            let
              outputCfg = config.programs.niri.settings.outputs;
            in
            builtins.getAttr config.hostname {
              aladdin = {
                DP-3 = {
                  focus-at-startup = true;
                  variable-refresh-rate = "on-demand";
                  position.x = 0;
                  position.y = 0;
                  mode = {
                    width = 1920;
                    height = 1080;
                    refresh = 239.757;
                  };
                };
                HDMI-A-1 = {
                  position.x = outputCfg.DP-3.mode.width;
                  position.y = 500;
                };
              };
            };
          layer-rules = [
            {
              matches = [ { namespace = "^notifications$"; } ];
              block-out-from = "screencast";
            }
          ];
          window-rules = [
            {
              draw-border-with-background = false;
              clip-to-geometry = true;
              geometry-corner-radius =
                let
                  radius = 8.0;
                in
                {
                  top-left = radius;
                  top-right = radius;
                  bottom-left = radius;
                  bottom-right = radius;
                };
            }
            {
              matches = [ { app-id = "^firefox$"; } ];
              open-maximized = true;
            }
            {
              matches = lib.singleton {
                app-id = "^firefox$";
                title = "^Picture-in-Picture$";
              };
              open-floating = true;
            }
            {
              matches = [ { app-id = "^vesktop$"; } ];
              open-maximized = true;
              block-out-from = "screencast";
            }
            {
              matches = [ { app-id = "^kitty$"; } ];
              default-column-width.proportion = 1.0 / 2.0;
              default-window-height = { };
            }
          ];
          binds = {
            "Mod+T" = {
              repeat = false;
              action.spawn = "kitty";
            };
            "Mod+Q" = {
              repeat = false;
              action.spawn = [
                "kitten"
                "quick-access-terminal"
              ];
            };

            "Mod+Ctrl+Shift+Alt+L".action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "lockScreen"
              "lock"
            ];

            "Mod+D".action.spawn = "vesktop";
            "Mod+B".action.spawn = "firefox";
            "Mod+BackSpace".action.close-window = { };
            "Mod+C".action.center-column = { };
            "Mod+Ctrl+C".action.center-visible-columns = { };

            "Mod+R".action.switch-preset-column-width = { };
            "Mod+Shift+R".action.switch-preset-window-height = { };
            "Mod+Ctrl+R".action.reset-window-height = { };

            "Mod+Space".action.spawn = [
              "rofi"
              "-show"
              "drun"
              "-show-icons"
            ];
            "Mod+E".action.spawn = [
              "rofi"
              "-show"
              "emoji"
            ];
            "Mod+W".action.spawn = [
              "rofi"
              "-show"
              "calc"
            ];

            "Mod+O".action.toggle-overview = { };
            "Mod+M".action.quit = { };
            "Mod+Ctrl+Shift+M".action.quit.skip-confirmation = true;

            "Mod+P".action.screenshot.show-pointer = false;
            "Mod+Alt+P".action.screenshot-screen.show-pointer = false;
            "Mod+Shift+P".action.screenshot-window = { };

            "Mod+H".action.focus-column-left = { };
            "Mod+J".action.focus-window-or-workspace-down = { };
            "Mod+K".action.focus-window-or-workspace-up = { };
            "Mod+L".action.focus-column-right = { };

            "Mod+Shift+H".action.move-column-left = { };
            "Mod+Shift+J".action.move-window-down-or-to-workspace-down = { };
            "Mod+Shift+K".action.move-window-up-or-to-workspace-up = { };
            "Mod+Shift+L".action.move-column-right = { };

            "Mod+Minus".action.set-column-width = "-10%";
            "Mod+Plus".action.set-column-width = "+10%";
            "Mod+Ctrl+Minus".action.set-window-height = "-10%";
            "Mod+Ctrl+Plus".action.set-window-height = "+10%";

            "Mod+F".action.maximize-column = { };
            "Mod+Shift+F".action.fullscreen-window = { };
            "Mod+Ctrl+F".action.expand-column-to-available-width = { };

            "Mod+V".action.toggle-window-floating = { };
            "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };

            XF86AudioMute = {
              allow-when-locked = true;
              action.spawn = [
                "wpctl"
                "set-mute"
                "@DEFAULT_AUDIO_SINK@"
                "toggle"
              ];
            };
            XF86AudioMicMute = {
              allow-when-locked = true;
              action.spawn = [
                "wpctl"
                "set-mute"
                "@DEFAULT_AUDIO_SOURCE@"
                "toggle"
              ];
            };
            XF86AudioRaiseVolume = {
              allow-when-locked = true;
              action.spawn = [
                "wpctl"
                "set-volume"
                "-l"
                "1.0"
                "@DEFAULT_AUDIO_SINK@"
                "5%+"
              ];
            };
            XF86AudioLowerVolume = {
              allow-when-locked = true;
              action.spawn = [
                "wpctl"
                "set-volume"
                "@DEFAULT_AUDIO_SINK@"
                "5%-"
              ];
            };
            XF86MonBrightnessUp = {
              allow-when-locked = true;
              action.spawn = [
                "sh"
                "-c"
                "brightnessctl"
                "set"
                "5%+"
              ];
            };
            XF86MonBrightnessDown = {
              allow-when-locked = true;
              action.spawn = [
                "sh"
                "-c"
                "brightnessctl"
                "set"
                "5%-"
              ];
            };
            XF86AudioPlay = {
              allow-when-locked = true;
              action.spawn = [
                "playerctl"
                "play-pause"
              ];
            };
            XF86AudioPrev = {
              allow-when-locked = true;
              action.spawn = [
                "playerctl"
                "previous"
              ];
            };
            XF86AudioNext = {
              allow-when-locked = true;
              action.spawn = [
                "playerctl"
                "next"
              ];
            };
          }
          // (
            {
              key = [
                "H"
                "J"
                "K"
                "L"
              ];
              cmd = [
                "focus-monitor"
                "move-column-to-monitor"
                "move-workspace-to-monitor"
              ];
            }
            |> lib.mapCartesianProduct (
              { key, cmd }:
              let
                direction = builtins.getAttr key {
                  H = "left";
                  J = "down";
                  K = "up";
                  L = "right";
                };
                combination = builtins.getAttr cmd {
                  focus-monitor = "Ctrl";
                  move-column-to-monitor = "Shift+Alt";
                  move-workspace-to-monitor = "Shift+Ctrl";
                };
              in
              lib.nameValuePair "Mod+${combination}+${key}" { action."${cmd}-${direction}" = { }; }
            )
            |> builtins.listToAttrs
          )
          // (
            9
            |> builtins.genList (
              i:
              let
                wp = i + 1;
              in
              [
                (lib.nameValuePair "Mod+${toString wp}" { action.focus-workspace = wp; })
                (lib.nameValuePair "Mod+Ctrl+${toString wp}" { action.move-column-to-workspace = wp; })
              ]
            )
            |> lib.flatten
            |> builtins.listToAttrs
          );
        };
      };
    }
  );
}

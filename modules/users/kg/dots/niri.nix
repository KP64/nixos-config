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

      # TODO: Window rules
      #         - to block specifics from screensharing
      programs.niri = {
        enable = true;
        package = niri-unstable;
        settings = {
          xwayland-satellite.path = lib.getExe xwayland-satellite-unstable;
          prefer-no-csd = true;
          clipboard.disable-primary = true; # Disable middle click paste
          gestures.hot-corners.enable = false;
          overview = {
            backdrop-color = "#11111b";
            workspace-shadow.enable = false;
          };
          layout = {
            always-center-single-column = true;
            gaps = 4;
            focus-ring = {
              width = 2;
              active.color = "#7287fd"; # Catppuccin Mocha Lavender
              inactive.color = "#11111b"; # Catppuccin Mocha Crust
              urgent.color = "#74c7ec"; # Catppuccin Mocha Sapphire
            };
            # TODO:
            # preset-column-width = [ ];
            default-column-width.proportion = 1.0 / 3.0;
          };
          input = {
            keyboard.xkb = {
              layout = "de";
              options = "caps:escape";
            };
            mouse.scroll-button-lock = true;
          };
          outputs =
            let
              cfg = config.programs.niri.settings.outputs;
            in
            {
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
                position.x = cfg.DP-3.mode.width;
                position.y = 500;
              };
            };
          cursor = {
            hide-after-inactive-ms = 1000;
            size = 32;
          };
          binds = {
            "Mod+T" = {
              repeat = false;
              action.spawn = "kitty";
            };
            "Mod+D" = {
              repeat = false;
              action.spawn = [
                "kitten"
                "quick-access-terminal"
              ];
            };

            "Mod+B".action.spawn = "firefox";
            "Mod+C".action.close-window = { };

            "Mod+R".action.spawn = [
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
            "Mod+Shift+M".action.quit.skip-confirmation = true;

            "Mod+P".action.screenshot = { };
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

            "Mod+Ctrl+H".action.focus-monitor-left = { };
            "Mod+Ctrl+J".action.focus-monitor-down = { };
            "Mod+Ctrl+K".action.focus-monitor-up = { };
            "Mod+Ctrl+L".action.focus-monitor-right = { };

            "Mod+Minus".action.set-column-width = "-10%";
            "Mod+Plus".action.set-column-width = "+10%";
            "Mod+Ctrl+Minus".action.set-window-height = "-10%";
            "Mod+Ctrl+Plus".action.set-window-height = "+10%";

            "Mod+F".action.fullscreen-window = { };
            "Mod+V".action.toggle-window-floating = { };

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

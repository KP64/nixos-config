toplevel: {
  den.aspects.kg._.niri = {
    nixos.programs.niri.enable = true;

    # NOTE: Don't forget to install wireplumber on the device
    #       Reason: without it volume keybinds won't work
    homeManager =
      { host, ... }:
      {
        osConfig ? null,
        config,
        lib,
        pkgs,
        ...
      }:
      let
        # this is only done like that to generate eval errors should
        # these hosts not be available anymore.
        aladdin = toplevel.config.flake.nixosConfigurations.aladdin.config.networking.hostName;
      in
      {
        services.playerctld.enable = true;

        home.packages = [ pkgs.wl-clipboard-rs ];

        wayland.windowManager.niri =
          (lib.optionalAttrs (osConfig != null) {
            package = null;
            portalPackage = null;
            systemd.enable = false;
          })
          // {
            enable = true;
            settings = {
              prefer-no-csd = { };
              environment.ELECTRON_OZONE_PLATFORM_HINT = "auto";
              clipboard.disable-primary = { }; # Disables middle click paste
              gestures.hot-corners.off = { };
              hotkey-overlay.skip-at-startup = { };
              debug.honor-xdg-activation-with-invalid-serial = { };
              overview = {
                backdrop-color = "#11111b";
                workspace-shadow.off = { };
              };
              layout = {
                always-center-single-column = { };
                gaps = 8;
                border = {
                  width = 2;
                  active-color = "#9399b2"; # Catppuccin Mocha Overlay 2
                  inactive-color = "#11111b"; # Catppuccin Mocha Crust
                  urgent-color = "#74c7ec"; # Catppuccin Mocha Sapphire
                };
                focus-ring.off = { };
                preset-column-widths._children = map (proportion: { inherit proportion; }) [
                  (1.0 / 4.0)
                  (1.0 / 3.0)
                  (1.0 / 2.0)
                  (2.0 / 3.0)
                  (5.0 / 6.0)
                ];
                default-column-width.proportion = 1.0 / 3.0;
              };
              input = {
                keyboard = {
                  xkb = {
                    layout = "de";
                    model = "";
                    rules = "";
                    variant = "";
                    options = "caps:escape";
                  };
                  repeat-delay = 600;
                  repeat-rate = 25;
                  track-layout = "global";
                };
                touchpad = {
                  tap = { };
                  natural-scroll = { };
                };
                mouse.scroll-button-lock = { };
              };
              _children =
                (
                  {
                    sindbad = {
                      eDP-1 = {
                        focus-at-startup = { };
                        scale = 1.0;
                      };
                    };
                    ${aladdin} = {
                      DP-3 = {
                        focus-at-startup = { };
                        transform = "normal";
                        variable-refresh-rate._props.on-demand = true;
                        position._props = {
                          x = 0;
                          y = 0;
                        };
                        mode = "1920x1080@239.757";
                      };
                      HDMI-A-1 = {
                        transform = "normal";
                        position._props = {
                          x = 1920;
                          y = 500;
                        };
                      };
                    };
                  }
                  |> builtins.getAttr host.name
                  |> lib.mapAttrsToList (
                    outputName: arguments: {
                      output = {
                        _args = [ outputName ];
                      }
                      // arguments;
                    }
                  )
                )
                ++ [
                  {
                    layer-rule = {
                      match._props.namespace = "^notifications$";
                      block-out-from = "screencast";
                    };
                  }
                  {
                    window-rule = {
                      draw-border-with-background = false;
                      clip-to-geometry = true;
                      geometry-corner-radius = builtins.genList (_: 8.0) 4;
                    };
                  }
                  {
                    window-rule = {
                      match._props.app-id = "^firefox$";
                      open-maximized = true;
                    };
                  }
                  {
                    window-rule = {
                      match._props = {
                        app-id = "^firefox$";
                        title = "^Picture-in-Picture$";
                      };
                      open-floating = true;
                    };
                  }
                  {
                    window-rule = {
                      match._props.app-id = "^kitty$";
                      default-column-width.proportion = 1.0 / 2.0;
                      default-window-height = { };
                    };
                  }
                  {
                    window-rule = {
                      _children =
                        let
                          ids = [
                            "Minecraft"
                            "steam_app"
                          ];
                        in
                        lib.forEach ids (id: {
                          match._props.app-id = "${id}*";
                        });
                      variable-refresh-rate = true;
                      open-on-output = lib.mkIf (host.name == aladdin) "DP-3";
                    };
                  }
                ];
              spawn-at-startup = lib.optional (config.programs.noctalia.enable or false) "noctalia";

              binds =
                let
                  brightnessctl = lib.getExe pkgs.brightnessctl;
                in
                (
                  let
                    noctaliaMsg = [
                      "noctalia"
                      "msg"
                    ];
                  in
                  lib.optionalAttrs (config.programs.noctalia.enable or false) {
                    "Mod+Ctrl+Shift+Alt+L".spawn = noctaliaMsg ++ [
                      "session"
                      "lock"
                    ];
                    "Mod+Space".spawn = noctaliaMsg ++ [
                      "panel-toggle"
                      "launcher"
                    ];
                  }
                )
                // {
                  "Mod+T" = {
                    _props.repeat = false;
                    spawn = [ "kitty" ];
                  };
                  "Mod+Q" = {
                    _props.repeat = false;
                    spawn = [
                      "kitten"
                      "quick-access-terminal"
                    ];
                  };

                  "Mod+B".spawn = [ "firefox" ];
                  "Mod+BackSpace".close-window = { };
                  "Mod+C".center-column = { };
                  "Mod+Ctrl+C".center-visible-columns = { };

                  "Mod+R".switch-preset-column-width = { };
                  "Mod+Shift+R".switch-preset-window-height = { };
                  "Mod+Ctrl+R".reset-window-height = { };

                  "Mod+O".toggle-overview = { };
                  "Mod+M".quit = { };
                  "Mod+Ctrl+Shift+M".quit._props.skip-confirmation = true;

                  "Mod+P".screenshot._props.show-pointer = false;
                  "Mod+Alt+P".screenshot-screen._props.show-pointer = false;
                  "Mod+Shift+P".screenshot-window = { };

                  "Mod+H".focus-column-left = { };
                  "Mod+J".focus-window-or-workspace-down = { };
                  "Mod+K".focus-window-or-workspace-up = { };
                  "Mod+L".focus-column-right = { };

                  "Mod+Shift+H".move-column-left = { };
                  "Mod+Shift+J".move-window-down-or-to-workspace-down = { };
                  "Mod+Shift+K".move-window-up-or-to-workspace-up = { };
                  "Mod+Shift+L".move-column-right = { };

                  "Mod+Minus".set-column-width = "-10%";
                  "Mod+Plus".set-column-width = "+10%";
                  "Mod+Ctrl+Minus".set-window-height = "-10%";
                  "Mod+Ctrl+Plus".set-window-height = "+10%";

                  "Mod+F".maximize-column = { };
                  "Mod+Shift+F".fullscreen-window = { };
                  "Mod+Ctrl+F".expand-column-to-available-width = { };

                  "Mod+V".toggle-window-floating = { };
                  "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };

                  XF86AudioMute = {
                    _props.allow-when-locked = true;
                    spawn = [
                      "wpctl"
                      "set-mute"
                      "@DEFAULT_AUDIO_SINK@"
                      "toggle"
                    ];
                  };
                  XF86AudioMicMute = {
                    _props.allow-when-locked = true;
                    spawn = [
                      "wpctl"
                      "set-mute"
                      "@DEFAULT_AUDIO_SOURCE@"
                      "toggle"
                    ];
                  };
                  XF86AudioRaiseVolume = {
                    _props.allow-when-locked = true;
                    spawn = [
                      "wpctl"
                      "set-volume"
                      "-l"
                      "1.0"
                      "@DEFAULT_AUDIO_SINK@"
                      "5%+"
                    ];
                  };
                  XF86AudioLowerVolume = {
                    _props.allow-when-locked = true;
                    spawn = [
                      "wpctl"
                      "set-volume"
                      "@DEFAULT_AUDIO_SINK@"
                      "5%-"
                    ];
                  };
                  XF86MonBrightnessUp = {
                    _props.allow-when-locked = true;
                    spawn = [
                      brightnessctl
                      "set"
                      "5%+"
                    ];
                  };
                  XF86MonBrightnessDown = {
                    _props.allow-when-locked = true;
                    spawn = [
                      brightnessctl
                      "set"
                      "5%-"
                    ];
                  };
                  XF86AudioPlay = {
                    _props.allow-when-locked = true;
                    spawn = [
                      "playerctl"
                      "play-pause"
                    ];
                  };
                  XF86AudioPrev = {
                    _props.allow-when-locked = true;
                    spawn = [
                      "playerctl"
                      "previous"
                    ];
                  };
                  XF86AudioNext = {
                    _props.allow-when-locked = true;
                    spawn = [
                      "playerctl"
                      "next"
                    ];
                  };
                }
                // (
                  builtins.listToAttrs
                  <| lib.mapCartesianProduct (
                    { key, cmd }:
                    let
                      direction =
                        {
                          H = "left";
                          J = "down";
                          K = "up";
                          L = "right";
                        }
                        .${key};
                      combination =
                        {
                          focus-monitor = "Ctrl";
                          move-column-to-monitor = "Shift+Alt";
                          move-workspace-to-monitor = "Shift+Ctrl";
                        }
                        .${cmd};
                    in
                    lib.nameValuePair "Mod+${combination}+${key}" { "${cmd}-${direction}" = { }; }
                  )
                  <| {
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
                )
                // (
                  9
                  |> builtins.genList (
                    i:
                    let
                      wp = i + 1;
                    in
                    [
                      (lib.nameValuePair "Mod+${toString wp}" { focus-workspace = wp; })
                      (lib.nameValuePair "Mod+Ctrl+${toString wp}" { move-column-to-workspace = wp; })
                    ]
                  )
                  |> lib.flatten
                  |> builtins.listToAttrs
                );
            };
          };
      };
  };
}

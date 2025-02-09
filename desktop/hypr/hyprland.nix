{
  lib,
  config,
  pkgs,
  inputs,
  username,
  ...
}:

let
  cfg = config.desktop.hypr.hyprland;
  max_workspace_count = 9;
in
{
  options = {
    maxWorkspaceCount = lib.mkOption {
      internal = true;
      type = lib.types.ints.positive;
      default = max_workspace_count;
    };

    desktop.hypr.hyprland = {
      enable = lib.mkEnableOption "Hyprland";
      monitors = lib.mkOption {
        readOnly = true;
        type = lib.types.nonEmptyListOf (
          lib.types.submodule {
            options = {
              enabled = lib.mkOption {
                default = true;
                type = lib.types.bool;
                description = "Whether the monitor is enabled.";
                example = false;
              };
              name = lib.mkOption {
                readOnly = true;
                type = lib.types.nonEmptyStr;
                description = "The descriptor of the Monitor.";
                example = "DP-1";
              };
              resolution = lib.mkOption {
                default = "preferred";
                type = lib.types.enum [
                  "preferred"
                  "highres"
                  "highrr"
                ];
                example = "highres";
              };
              x = lib.mkOption {
                type = lib.types.int;
                default = 0;
                example = 1920;
              };
              y = lib.mkOption {
                type = lib.types.int;
                default = 0;
                example = 1080;
              };
              vrr = lib.mkOption {
                type = lib.types.ints.between 0 2;
                default = 0;
                example = 1;
              };
              workspaces = lib.mkOption {
                default = [ ];
                description = "The workspaces to be assigned to the monitor.";
                type = lib.types.listOf (
                  lib.types.submodule {
                    options = {
                      id = lib.mkOption {
                        readOnly = true;
                        type = lib.types.ints.between 1 max_workspace_count;
                        example = 1;
                      };
                      default = lib.mkEnableOption "this workspace always on this monitor";
                    };
                  }
                );
              };
            };
          }
        );
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # System wide install needed for e.g. SDDM
    programs.hyprland.enable = true;

    home-manager.users.${username} = {
      home.packages = with inputs; [
        hyprpicker.packages.${pkgs.system}.hyprpicker
        hyprland-contrib.packages.${pkgs.system}.grimblast
        hyprpolkitagent.packages.${pkgs.system}.hyprpolkitagent
        hyprsunset.packages.${pkgs.system}.hyprsunset
      ];
      wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        systemd.variables = [ "--all" ];
        # plugins = [ inputs.hyprgrass.packages.${pkgs.system}.default ];
        settings = {
          # plugin.touch_gestures = {
          #   sensitivity = 4.0;

          #   workspace_swipe_fingers = 3;
          #   workspace_swipe_cancel_ratio = 0.1;

          #   workspace_swipe_edge = "u";

          #   hyprgrass-bindm = [
          #     ", longpress:2, movewindow"
          #     ", longpress:3, resizewindow"
          #   ];

          #   long_press_delay = 400;

          #   resize_on_boder_long_press = true;

          #   edge_margin = 10;
          # };

          env =
            let
              stylixCursor = config.stylix.cursor;
            in
            lib.optionals config.isStylixEnabled [
              "XCURSOR_SIZE,${toString stylixCursor.size}"
              "XCURSOR_THEME,${stylixCursor.name}"
            ];

          monitor =
            cfg.monitors
            |> map (
              m:
              let
                position = "${toString m.x}x${toString m.y}";
              in
              "${m.name}, ${
                if m.enabled then "${m.resolution}, ${position}, auto, vrr, ${toString m.vrr}" else "disable"
              }"
            );

          workspace =
            cfg.monitors
            |> map (
              m:
              m.workspaces
              |> map (w: "${toString w.id}, monitor:${m.name}, default:${lib.boolToString w.default}")
            )
            |> lib.flatten;

          "$terminal" = "kitty";
          "$browser" = "firefox";
          "$menu" = "rofi -show drun -show-icons";
          "$emenu" = "rofi -modi emoji -show emoji";
          "$mainMod" = "SUPER";

          exec-once = [
            "copyq --start-server"
            "mako"
            "udiskie"
            "hyprpaper"
            "hypridle"
            "eww daemon"
          ];

          general = lib.mkIf config.isCatppuccinEnabled {
            "col.active_border" = "$lavender";
            "col.inactive_border" = "$surface0";
          };

          decoration = {
            rounding = 8;

            shadow.color = lib.mkIf config.isCatppuccinEnabled "$mantle";

            blur = {
              enabled = true;
              size = 2;
            };
          };

          animations = {
            enabled = true;
            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };

          dwindle = {
            pseudotile = true;
            smart_split = true;
          };

          render.direct_scanout = true;

          misc = {
            force_default_wallpaper = -1;
            disable_hyprland_logo = true;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
          };

          input = {
            kb_layout = "de";
            follow_mouse = 1;
          };

          binde = [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ];

          bind =
            [ ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" ]
            ++ map (s: "$mainMod, ${s}") [
              "T, exec, $terminal"
              "F, exec, $browser"
              "R, exec, $menu"
              "E, exec, $emenu"

              "C, killactive,"
              "M, exit,"
              "V, togglefloating,"
              "P, pseudo,"
              "J, togglesplit,"

              "left, movefocus, l"
              "right, movefocus, r"
              "up, movefocus, u"
              "down, movefocus, d"

              "H, togglespecialworkspace, magic"

              "mouse_down, workspace, e+1"
              "mouse_up, workspace, e-1"
            ]
            ++ map (s: "$mainMod SHIFT, ${s}") [
              "J, swapsplit"
              "C, exec, hyprpicker --no-fancy --autocopy"
              "R, exec, systemctl --user restart waybar.service"
              "S, exec, grimblast --freeze --notify copysave area"
              "H, movetoworkspace, special:magic"
              "right, movetoworkspace, e+1"
              "left, movetoworkspace, e-1"
            ]
            ++ (
              # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
              max_workspace_count
              |> builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "$mainMod, code:1${toString i}, workspace, ${toString ws}"
                  "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              )
              |> builtins.concatLists
            );

          bindm = map (s: "$mainMod, ${s}") [
            "mouse:272, movewindow"
            "mouse:273, resizewindow"
          ];

          windowrulev2 =
            let
              titles = map (game: "title:^(${game})$") [
                "DOOMEternal"
                "Need for Speed™ Most Wanted"
                "METAL GEAR RISING: REVENGEANCE"
              ];
              classes = map (engine: "class:^(${engine})$") [
                "lt-love"
                "dolphin-emu"
              ];
            in
            [
              "suppressevent maximize, class:.*"
              "fullscreenstate 3, class:^(Monopoly Plus)$"
            ]
            ++ map (s: "fullscreen, ${s}") (titles ++ classes);
        };
      };
    };
  };
}

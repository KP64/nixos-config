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
in
{
  options.desktop.hypr.hyprland = with lib; {
    enable = mkEnableOption "Enables Hyprland";
    monitors = mkOption {
      readOnly = true;
      type = types.listOf (
        types.submodule {
          options = {
            enabled = mkOption {
              type = types.bool;
              default = true;
            };
            name = mkOption {
              type = types.str;
              example = "DP-1";
            };
            resolution = mkOption {
              type = types.enum [
                "preferred"
                "highres"
                "highrr"
              ];
              default = "preferred";
              example = "highres";
            };
            x = mkOption {
              type = types.int;
              default = 0;
              example = 1920;
            };
            y = mkOption {
              type = types.int;
              default = 0;
              example = 1080;
            };
            vrr = mkOption {
              type = types.ints.between 0 2;
              default = 0;
              example = 1;
            };
          };
        }
      );
    };

    workspaces = mkOption {
      readOnly = true;
      type = types.listOf (
        types.submodule {
          options = {
            id = mkOption {
              type = types.ints.between 1 10;
              example = 1;
            };
            monitorName = mkOption {
              type = types.str;
              example = "DP-1";
            };
            default = mkOption {
              type = types.bool;
              default = false;
              example = true;
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    environment = {
      pathsToLink = map (p: "/share/${p}") [
        "xdg-desktop-portal"
        "applications"
      ];
      sessionVariables.NIXOS_OZONE_WL = "1";
    };

    # System wide install needed for e.g. SDDM
    programs.hyprland.enable = true;
    home-manager.users.${username} = {
      home.packages =
        [ inputs.hyprland-contrib.packages.${pkgs.system}.grimblast ]
        ++ (with pkgs; [
          kdePackages.dolphin
          hyprpanel
          hyprpicker
        ]);
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.variables = [ "--all" ];
        settings = {
          monitor = map (
            m:
            let
              position = "${toString m.x}x${toString m.y}";
            in
            "${m.name}, ${
              if m.enabled then "${m.resolution}, ${position}, auto, vrr, ${toString m.vrr}" else "disable"
            }"
          ) cfg.monitors;

          workspace = map (
            w: "${toString w.id}, monitor:${w.monitorName}, default:${lib.boolToString w.default}"
          ) cfg.workspaces;

          "$terminal" = "kitty";
          "$browser" = "firefox";
          "$menu" = "rofi -show drun -show-icons";
          "$emenu" = "rofi -modi emoji -show emoji";
          "$mainMod" = "SUPER";

          exec-once = [
            "copyq --start-server"
            "mako"
            "hyprpanel"
            "udiskie"
            "hyprpaper"
            "hypridle"
            "eww daemon"
          ];

          general = {
            "col.active_border" = "$lavender";
            "col.inactive_border" = "$surface0";
          };

          decoration = {
            rounding = 8;

            "col.shadow" = "$mantle";
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
            [
              ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ]
            ++ map (s: "$mainMod, ${s}") [
              "T, exec, $terminal"
              "C, killactive,"
              "M, exit,"
              "F, exec, $browser"
              "V, togglefloating,"
              "R, exec, $menu"
              "E, exec, $emenu"
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
              # binds $mainMod + [shift +] (0, {1..9}) to [move to] workspace (10, {1..9})
              builtins.concatLists (
                builtins.genList (
                  x:
                  let
                    c = (x + 1) / 10;
                    ws = toString (x + 1 - (c * 10));
                  in
                  [
                    "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
                    "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                  ]
                ) 10
              )
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
              # "workspace 1, class:^(Monopoly Plus)$"
              "fullscreenstate 3, class:^(Monopoly Plus)$"
            ]
            ++ map (s: "fullscreen, ${s}") (titles ++ classes);
        };
      };
    };
  };
}

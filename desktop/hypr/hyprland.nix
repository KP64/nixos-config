{
  pkgs,
  lib,
  config,
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
      pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];
      sessionVariables.NIXOS_OZONE_WL = "1";
    };

    # System wide install needed for e.g. SDDM
    programs.hyprland.enable = true;
    home-manager.users.${username}.wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
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
        "$mainMod" = "SUPER";

        exec-once = [
          "copyq --start-server"
          "mako"
          "udiskie"
          "hyprpaper"
          "hypridle"
          "eww daemon"
        ];

        general = {
          "col.active_border" = "$rosewater $sapphire $green 45deg";
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

        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = true;
          # Direct Scanout == Less Input Delay
          # Could produce graphical glitches though
          no_direct_scanout = false;

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

            "$mainMod, T, exec, $terminal"
            "$mainMod, C, killactive,"
            "$mainMod, M, exit,"
            "$mainMod, F, exec, $browser"
            "$mainMod, V, togglefloating,"
            "$mainMod, R, exec, $menu"
            "$mainMod, P, pseudo,"

            "$mainMod, J, togglesplit,"
            "$mainMod SHIFT, J, swapsplit"

            "$mainMod SHIFT, C, exec, hyprpicker --no-fancy --autocopy"
            "$mainMod SHIFT, R, exec, systemctl --user restart waybar.service"
            "$mainMod SHIFT, S, exec, grimblast --freeze --notify copysave area"

            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"

            "$mainMod, H, togglespecialworkspace, magic"
            "$mainMod SHIFT, H, movetoworkspace, special:magic"

            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod SHIFT, right, movetoworkspace, e+1"

            "$mainMod, mouse_up, workspace, e-1"
            "$mainMod SHIFT, left, movetoworkspace, e-1"
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

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        windowrulev2 = [
          "suppressevent maximize, class:.*"
          "fullscreen, title:^(DOOMEternal)$"
          "fullscreen, class:^(lt-love)$"
          "fullscreen, title:^(Need for Speed™ Most Wanted)"
          "fullscreen, title:^(METAL GEAR RISING: REVENGEANCE)$"
        ];
      };
    };
  };
}

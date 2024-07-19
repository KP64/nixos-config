{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:
{
  options.desktop.hypr.hyprland.enable = lib.mkEnableOption "Enables Hyprland";

  config = lib.mkIf config.desktop.hypr.hyprland.enable {
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
        monitor = [
          "desc:Dell Inc. AW2521HF CVTLL03, highrr, 0x0, auto, vrr, 2"
          "desc:Dell Inc. DELL SE2216H 2V32398VA14I, preferred, 1920x500, auto"
        ];

        workspace = [
          "1, monitor:desc:Dell Inc. AW2521HF CVTLL03, default:true"
          "2, monitor:desc:Dell Inc. DELL SE2216H 2V32398VA14I, default:true"
        ];

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
                  ws = builtins.toString (x + 1 - (c * 10));
                in
                [
                  "$mainMod, ${ws}, workspace, ${builtins.toString (x + 1)}"
                  "$mainMod SHIFT, ${ws}, movetoworkspace, ${builtins.toString (x + 1)}"
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

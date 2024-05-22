catppuccin:
{ inputs, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    inherit catppuccin;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    systemd.variables = [ "--all" ];
    settings = {
      monitor = [
        "desc:Dell Inc. AW2521HF CVTLL03, highrr, 0x0, auto, vrr, 2"
        "desc:Dell Inc. DELL SE2216H 2V32398VA14I, preferred, 1920x500, auto"
        "Unknown-1, disable" # TODO: Is Unknown a bug from Hyprland itself?
      ];

      workspace = [
        "1, monitor:desc:Dell Inc. AW2521HF CVTLL03, default:true"
        "2, monitor:desc:Dell Inc. DELL SE2216H 2V32398VA14I, default:true"
      ];

      "$terminal" = "kitty";
      "$browser" = "firefox";
      "$menu" = "rofi -show drun -show-icons";
      "$mainMod" = "SUPER";

      exec-once = "copyq --start-server & mako & udiskie & hypridle";

      env = [
        "XCURSOR_SIZE, 24"
        "HYPRCURSOR, 24"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 20;

        border_size = 2;

        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        resize_on_border = false;

        # Tearing causes Blackscreen in Games
        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
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
        preserve_split = true;
      };

      master = {
        new_is_master = true;
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
        # Direct Scanout == Less Input Delay
        no_direct_scanout = false;
      };

      input = {
        kb_layout = "de";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      gestures = {
        workspace_swipe = false;
      };

      bind =
        [
          "$mainMod, Q, exec, $terminal"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, F, exec, $browser"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, $menu"
          "$mainMod, P, pseudo,"
          "$mainMod, J, togglesplit,"
          "$mainMod SHIFT, R, exec, systemctl --user restart waybar.service"
          "$mainMod SHIFT, S, exec, grimblast --freeze --notify copysave area"

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          "$mainMod, H, togglespecialworkspace, magic"
          "$mainMod SHIFT, H, movetoworkspace, special:magic"

          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ]
        ++ (
          # binds $mainMod + [shift +] (0, {1..9}) to [move to] workspace (10, {1..9})
          builtins.concatLists (
            builtins.genList (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
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

        # TODO: Activate when Screen Tearing is fixed. See Above.
        # "immediate, title:^(Rocket League \\(64-bit, DX11, Cooked\\))$" # Capture all nums?: ^(steam_app)(.*)$
      ];
    };
  };
}

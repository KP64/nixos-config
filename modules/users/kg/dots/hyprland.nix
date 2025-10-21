let
  mod = "SUPER";

  bind = b: "${mod}, ${b}";
  bind_shift = b: "${mod} SHIFT, ${b}";
in
{
  flake.modules.homeManager.users-kg =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        hyprpicker
        grimblast
      ];

      services.playerctld.enable = true;

      # TODO: Set on Per-Host basis (Specialisations could prove helpful?)
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.variables = [ "--all" ];
        settings = {
          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };

          # Discourages XWayland to be used. Useful for discord & stuff
          env = [ "ELECTRON_OZONE_PLATFORM_HINT,auto" ];

          monitorv2 = [
            {
              output = "DP-3";
              mode = "highrr";
              vrr = 2;
            }
            {
              output = "HDMI-A-1";
              mode = "preferred";
              position = "1920x500";
            }
          ];

          workspace = [
            "1, monitor:DP-3, default:true"
            "2, monitor:HDMI-A-1, default:true"
          ];

          decoration = {
            rounding = 8;

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

          render.direct_scanout = 2;

          misc = {
            disable_hyprland_logo = true;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
          };

          input = {
            kb_layout = "de";
            kb_options = "caps:escape";
          };

          bindel =
            let
              brightnessctl = lib.getExe pkgs.brightnessctl;
            in
            [
              ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
              ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              ", XF86MonBrightnessUp, exec, ${brightnessctl} set 5%+"
              ", XF86MonBrightnessDown, exec, ${brightnessctl} set 5%-"
            ];

          bindl = [
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            # Requires playerctl
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioPrev, exec, playerctl previous"
            ", XF86AudioNext, exec, playerctl next"
          ];

          bindd =
            map bind [
              "T, Terminal, exec, kitty"
              "D, Dropdown Terminal, exec, kitten quick-access-terminal"
              "B, Browser, exec, firefox"
            ]
            ++ map bind_shift [
              "C, Colorpicker, exec, hyprpicker --no-fancy --autocopy"
              "I, Screenshot, exec, grimblast --freeze --notify copysave area"
            ];

          bind = [
            "${mod} SHIFT, S, swapsplit"
          ]
          ++ map bind [
            "R, exec, rofi -show drun -show-icons"
            "E, exec, rofi -show emoji"
            "W, exec, rofi -show calc"

            "C, killactive,"
            "M, exit,"
            "V, togglefloating,"
            "P, pseudo,"
            "S, togglesplit,"

            "left, movefocus, l"
            "H, movefocus, l"

            "right, movefocus, r"
            "L, movefocus, r"

            "up, movefocus, u"
            "K, movefocus, u"

            "down, movefocus, d"
            "J, movefocus, d"
          ]
          ++ (
            9
            |> builtins.genList (
              i:
              let
                is = i |> toString;
                workspace = i + 1 |> toString;
              in
              [
                "${mod}, code:1${is}, workspace, ${workspace}"
                "${mod} SHIFT, code:1${is}, movetoworkspace, ${workspace}"
              ]
            )
            |> builtins.concatLists
          );

          bindm = map bind [
            "mouse:272, movewindow"
            "mouse:273, resizewindow"
          ];
        };
      };
    };
}

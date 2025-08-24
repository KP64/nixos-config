{ pkgs, ... }:
let
  mod = "SUPER";
in
{
  home.packages = with pkgs; [
    grimblast
    hyprpicker
  ];

  # TODO: Rice it
  # TODO: Use OsConfig to detect NixOS usage?
  #   -> Use package = portalPackage = null !
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];
    plugins = [ pkgs.hyprlandPlugins.hyprgrass ];
    settings = {
      plugin.touch_gestures = {
        sensitivity = 4.0;

        workspace_swipe_fingers = 3;
        workspace_swipe_cancel_ratio = 0.1;

        workspace_swipe_edge = "u";

        hyprgrass-bindm = [
          ", longpress:2, movewindow"
          ", longpress:3, resizewindow"
        ];

        long_press_delay = 400;

        resize_on_boder_long_press = true;

        edge_margin = 10;
      };

      workspace = [
        "1, monitor:DP-1, default:true"
        "2, monitor:HDMI-A-1, default:true"
      ];

      general = rec {
        allow_tearing = true;

        gaps_in = 5;
        gaps_out = gaps_in;

        # TODO: Rice it
        # "col.inactive_border" = "";
        # "col.active_border" = "";
      };

      decoration = {
        rounding = 8;

        blur = {
          enabled = true;
          size = 2;
        };
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
        # TODO: Reenable once this matures
        # When enabled, hyprland asks for permission to load
        # hyprgrass on every new generation. Annoying!
        enforce_permissions = false;
      };

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

      cursor = {
        default_monitor = "DP-3";
        hide_on_key_press = true;
      };

      misc = {
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      input = {
        kb_layout = "de";
        kb_options = "caps:swapescape";

        follow_mouse = 1;
      };

      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      bind =
        map (s: "${mod}, ${s}") [
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
        ++ [ "${mod} SHIFT, S, swapsplit" ]
        ++ (
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          9
          |> builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "${mod}, code:1${toString i}, workspace, ${toString ws}"
              "${mod} SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          |> builtins.concatLists
        );

      bindd =
        map (s: "${mod}, ${s}") [
          "T, Terminal, exec, kitty"
          "D, Dropdown Terminal, exec, kitten quick-access-terminal"

          "F, Browser, exec, firefox"

          "R, App Runner, exec, rofi -show drun -show-icons"
          "E, Emoji Selector, exec, rofi -show emoji"
          "W, Scientific Calculator, exec, rofi -show calc"
        ]
        ++ map (s: "${mod} SHIFT, ${s}") [
          "C, Color Picker, exec, hyprpicker --no-fancy --autocopy"
          "I, Screenshot, exec, grimblast --notify --freeze copysave area"
        ];

      bindm = map (s: "${mod}, ${s}") [
        "mouse:272, movewindow"
        "mouse:273, resizewindow"
      ];

      # TODO: Remove?
      # windowrule = [ "suppressevent maximize, class:.*" ];
    };
  };
}

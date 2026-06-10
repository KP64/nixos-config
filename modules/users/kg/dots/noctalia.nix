toplevel@{ self, inputs, ... }:
{
  flake-file.inputs.noctalia = {
    type = "github";
    owner = "noctalia-dev";
    repo = "noctalia";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.kg._.noctalia.homeManager =
    {
      osConfig ? null,
      config,
      ...
    }:
    let
      inherit (toplevel.config.lib.flake.util) getAsset;
    in
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = {
          bar = {
            default = {
              capsule = true;
              font_weight = 400;
              margin_ends = 10;
              position = "left";
            };
          };
          desktop_widgets = {
            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };
            schema_version = 2;
            widget = { };
            widget_order = [ ];
          };
          idle = {
            behavior = {
              lock = {
                action = "lock";
                enabled = osConfig != null;
                timeout = 600;
              };
              lock-and-suspend = {
                action = "lock_and_suspend";
                enabled = osConfig != null;
                timeout = 900;
              };
              screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 660;
              };
            };
            behavior_order = [
              "lock"
              "screen-off"
              "lock-and-suspend"
            ];
          };
          location.auto_locate = true;
          lockscreen_widgets = {
            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };
            schema_version = 2;
          };
          notification.layer = "overlay";
          osd = {
            orientation = "vertical";
            position = "center_right";
          };
          shell = {
            avatar_path = builtins.path {
              name = "profile-pic";
              path = "${self}/modules/users/${config.home.username}/pfp.jpg";
              recursive = false;
              sha256 = "sha256-Ah71B03bSn7MeHt/weKxp6aKoXxSre/ncXsCJ4MzLfg=";
            };
            launch_apps_as_systemd_services = true;
            offline_mode = true;
            panel = {
              open_near_click_control_center = true;
              open_near_click_session = true;
              open_near_click_wallpaper = true;
            };
            password_style = "random";
          };
          theme = {
            builtin = "Catppuccin";
            community_palette = "Catppuccin Lavender";
            source = "community";
          };
          wallpaper = {
            enabled = true;
            default.path = getAsset {
              file = "leaves.png";
              type = "wallpapers/catppuccin";
              sha256 = "sha256-eYs2/+JsFYfWifynLpU/cty1tXqs4YlXTaRGNbkHBb4=";
            };
            directory = builtins.path {
              name = "Wallpapers";
              path = "${self}/assets/wallpapers/catppuccin";
              sha256 = "sha256-Afbn4MWV8dtipIC2gdTlCN+gus9e5f8ijE8b4bwd6e4=";
            };
          };
        };
      };
    };
}

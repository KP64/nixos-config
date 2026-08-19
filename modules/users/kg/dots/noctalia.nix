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
          config_version = 12;
          bar = {
            default = {
              capsule = true;
              font_weight = 400;
              margin_ends = 10;
              position = "left";
            };
          };
          desktop_widgets.enabled = false;
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
          lockscreen.allow_empty_password = true;
          lockscreen_widgets.enabled = false;
          notification.layer = "overlay";
          osd = {
            orientation = "vertical";
            position_vertical = "center_right";
          };
          shell = {
            avatar_path = builtins.path {
              name = "profile-pic";
              path = "${self}/modules/users/${config.home.username}/pfp.jpg";
              recursive = false;
              sha256 = "sha256-Ah71B03bSn7MeHt/weKxp6aKoXxSre/ncXsCJ4MzLfg=";
            };
            launch_apps_as_systemd_services = true;
            offline_mode = false;
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
              path = "${self}/assets/wallpapers";
              sha256 = "sha256-0opPoQ00aV7p10UX0osqm9UoHbwldN8aULYDWyxObSA=";
            };
          };
        };
      };
    };
}

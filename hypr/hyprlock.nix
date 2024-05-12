{ inputs, pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;
    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
    settings = {
      general = {
        hide_cursor = true;
      };

      background = [
        {
          monitor = "";
          path = "/etc/nixos/wallpapers/default.jpg";
        }
      ];

      image = [
        {
          monitor = "";
          path = "/etc/nixos/wallpapers/default.jpg";
          size = 150;
          rounding = -1;
          border_color = "rgb(255, 255, 255)";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "200, 50";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgb(151515)";
          inner_color = "rgb(FFFFFF)";
          font_color = "rgb(10, 10, 10)";
          fade_on_empty = true;
          fade_timeout = 1000;
          placeholder_text = "";
          hide_input = false;
          rounding = -1;
          check_color = "rgb(204, 136, 34)";
          fail_color = "rgb(204, 34, 34)";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_transition = 300;
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1;
          invert_numlock = false;
          swap_font_color = false;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$TIME"'';
          color = "rgb(0, 0, 0)";
          font_size = 55;
          halign = "right";
          valign = "bottom";
          position = "-100, 100";
          shadow_passes = 5;
          shadow_size = 10;
        }
        {
          monitor = "";
          text = "$USER";
          color = "rgb(0, 0, 0)";
          font_size = 55;
          halign = "right";
          valign = "bottom";
          position = "-100, 200";
          shadow_passes = 5;
          shadow_size = 10;
        }
      ];
    };
  };
}

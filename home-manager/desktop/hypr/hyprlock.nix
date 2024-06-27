{ inputs, pkgs, ... }:

let
  mocha_source = inputs.hyprland-catppuccin + "/themes/mocha.conf";

  accent = "$lavender";
  accentAlpha = "$lavenderAlpha";
  font = "JetBrainsMono Nerd Font";
in
{
  programs.hyprlock = {
    enable = true;
    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;

    settings = {
      source = mocha_source;

      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = [
        {
          monitor = "";
          path = builtins.toString ../../wallpapers/nixos-wallpaper-catppuccin-mocha.png;
          blur_passes = 0;
          color = "$base";
        }
      ];

      label = [
        {
          monitor = "";
          text = ''cmd[update:30000] echo "$(date +"%R")"'';
          color = "$text";
          font_size = 90;
          font_family = font;
          position = "-30, 0";
          halign = "right";
          valign = "top";
        }
        {
          monitor = "";
          text = ''cmd[update:60000] echo "$(date +"%A, %d %B %Y")"'';
          color = "$text";
          font_size = 25;
          font_family = font;
          position = "-30, -150";
          halign = "right";
          valign = "top";
        }
      ];

      # image = [
      #   {
      #     monitor = "";
      #     path = "~/.face"; # TODO: Add IMG
      #     size = 100;
      #     border_color = accent;

      #     position = "0, 75";
      #     halign = "center";
      #     valign = "center";
      #   }
      # ];

      input-field = [
        {
          monitor = "";
          size = "300, 60";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = accent;
          inner_color = "$surface0";
          font_color = "$text";
          fade_on_empty = false;
          # Multiline HTML doesn't work for watever reason
          placeholder_text = # html
            ''<span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##${accentAlpha}">$USER</span></span>'';
          hide_input = false;
          check_color = accent;
          fail_color = "$red";
          fail_text = # html
            ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
          capslock_color = "$yellow";
          position = "0, -35";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}

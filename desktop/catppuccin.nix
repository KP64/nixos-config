{
  lib,
  inputs,
  username,
  ...
}:
let
  accent = "lavender";
in
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  catppuccin = {
    enable = true;
    inherit accent;
  };
  home-manager.users.${username} = {
    imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

    catppuccin = {
      enable = true;
      inherit accent;
      pointerCursor = {
        enable = true;
        accent = "dark";
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = "catppuccin-mocha-dark-cursors";
      };
    };

    gtk =
      {
        enable = true;
        catppuccin.icon.enable = true;
      }
      // lib.genAttrs
        [
          "gtk3"
          "gtk4"
        ]
        (
          _:
          lib.setAttrByPath [
            "extraConfig"
            "gtk-application-prefer-dark-theme"
          ] 1
        );

    qt =
      let
        name = "kvantum";
      in
      {
        enable = true;
        style = {
          inherit name;
        };
        platformTheme = {
          inherit name;
        };
      };
  };
}

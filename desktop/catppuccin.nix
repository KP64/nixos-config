{
  lib,
  inputs,
  username,
  ...
}:

{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  catppuccin.enable = true;
  home-manager.users.${username} = {
    imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
    catppuccin = {
      enable = true;
      pointerCursor = {
        enable = true;
        accent = "dark";
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

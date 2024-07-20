{ inputs, username, ... }:

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
    gtk = {
      enable = true;
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;

      catppuccin.icon.enable = true;
    };

    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };

}

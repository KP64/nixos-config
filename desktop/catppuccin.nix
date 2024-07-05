{
  # pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:

# FIXME: When disabling catppuccin => home.pointerCursor.name is used but not defined.
{
  imports = with inputs; [ catppuccin.nixosModules.catppuccin ];
  options.desktop.catppuccin.enable = lib.mkEnableOption "Enables Catppuccin";

  config = lib.mkIf config.desktop.catppuccin.enable {
    catppuccin.enable = true;
    home-manager.users.${username} = {
      imports = with inputs; [ catppuccin.homeManagerModules.catppuccin ];
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
        # iconTheme = {
        #   name = "Papirus-Dark";
        #   package = pkgs.catppuccin-papirus-folders;
        # };
      };

      qt = {
        enable = true;
        style.name = "kvantum";
        platformTheme.name = "kvantum";
      };
    };
  };
}

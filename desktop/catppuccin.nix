{
  lib,
  config,
  inputs,
  username,
  ...
}:
{
  imports = with inputs; [ catppuccin.nixosModules.catppuccin ];
  options.desktop.catppuccin.enable = lib.mkEnableOption "Enables Catppuccin";

  config = lib.mkIf config.desktop.catppuccin.enable {
    catppuccin.enable = true;
    home-manager.users.${username} = {
      imports = with inputs; [ catppuccin.homeManagerModules.catppuccin ];
      catppuccin.enable = true;

      # TODO: Refactor Them out?
      gtk = {
        enable = true;
        gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
      };

      qt = {
        enable = true;
        style.name = "kvantum";
        platformTheme.name = "kvantum";
      };
    };
  };
}

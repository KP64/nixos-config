{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.desktop.login.sddm.enable = lib.mkEnableOption "Enables sddm";

  # FIXME: Only logins to Steam instead of Hyprland
  # TODO: The cmd is wrong when hyprland is not enabled
  config = lib.mkIf config.desktop.login.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      catppuccin.background = builtins.toString ../assets/wallpapers/nix-wp-cat-mocha.png;
      package = pkgs.kdePackages.sddm;
    };
  };
}

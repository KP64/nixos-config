{
  pkgs,
  lib,
  config,
  username,
  ...
}:

{
  imports = [
    ./eww
    ./hypr
    ./services
    ./login

    ./catppuccin.nix
    ./rofi.nix
    ./waybar.nix
  ];

  options.desktop.enable = lib.mkEnableOption "Enables Desktop Utilities";

  config = lib.mkIf config.desktop.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        xdg-utils
        libnotify
      ];

      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
        };
        portal = {
          enable = true;
          xdgOpenUsePortal = true;
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
          config = {
            common.default = [ "gtk" ];
            hyprland.default = [
              "hyprland"
              "gtk"
            ];
          };
        };
      };
    };
  };
}

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

  options.desktop.defaults.enable = lib.mkEnableOption "Enables Desktop Utilities";

  config = lib.mkIf config.desktop.defaults.enable {
    environment.pathsToLink = map (p: "/share/${p}") [
      "xdg-desktop-portal"
      "applications"
    ];

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
      };
    };
  };
}

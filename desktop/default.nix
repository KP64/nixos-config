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

  options.desktop.defaults.enable = lib.mkEnableOption "Desktop Utils";

  config = lib.mkIf config.desktop.defaults.enable {
    environment.pathsToLink = map (p: "/share/${p}") [
      "xdg-desktop-portal"
      "applications"
    ];

    environment.persistence."/persist".users.${username}.directories = [
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Public"
      "Templates"
      "Videos"
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

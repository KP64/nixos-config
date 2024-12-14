{
  pkgs,
  lib,
  config,
  username,
  ...
}:

let
  cfg = config.desktop.defaults;
in
{
  imports = [
    ./eww
    ./hypr
    ./services
    ./login

    ./rofi.nix
    ./waybar.nix
  ];

  options.desktop.defaults.enable = lib.mkEnableOption "Desktop Utils";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.pathsToLink = map (p: "/share/${p}") [
        "xdg-desktop-portal"
        "applications"
      ];

      home-manager.users.${username} = {
        home.packages = with pkgs; [
          xdg-utils
          libnotify
        ];

        gtk.enable = true;
        qt.enable = true;

        xdg = {
          enable = true;
          userDirs = {
            enable = true;
            createDirectories = true;
          };
        };
      };
    })

    (lib.mkIf config.system.impermanence.enable {
      environment.persistence."/persist".users.${username}.directories = lib.optionals cfg.enable [
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Public"
        "Templates"
        "Videos"
      ];
    })
  ];
}

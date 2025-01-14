{
  pkgs,
  lib,
  config,
  username,
  ...
}:

let
  cfg = config.desktop;
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

  options.desktop = {
    enable = lib.mkEnableOption "Desktop";
    misc.enable = lib.mkEnableOption "Desktop Utils";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      desktop = {
        eww.enable = lib.mkDefault true;
        hypr.enable = lib.mkDefault true;
        services.enable = lib.mkDefault true;
        login.enable = lib.mkDefault true;
        rofi.enable = lib.mkDefault true;
        misc.enable = lib.mkDefault true;
      };
    })

    (lib.mkIf cfg.misc.enable {
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

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories = lib.optionals cfg.misc.enable [
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

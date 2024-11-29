{
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.gaming.defaults;
in
{
  imports = [
    ./emulators

    ./discord.nix
    ./gamemode.nix
    ./heroic.nix
    ./mangohud.nix
    ./steam.nix
  ];

  options.gaming.defaults.enable = lib.mkEnableOption "Some gaming Apps";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home-manager.users.${username}.home.packages = with pkgs; [
        wineWowPackages.waylandFull
        bottles
        atlauncher
        steam-run
        openarena
      ];
    })

    (lib.mkIf config.system.impermanence.enable {
      environment.persistence."/persist".users.${username}.directories = lib.optionals cfg.enable (
        map (p: ".local/share/${p}") [
          "ATLauncher"
          "bottles"
        ]
      );
    })
  ];
}

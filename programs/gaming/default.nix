{
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.gaming;
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

  options.gaming = {
    enable = lib.mkEnableOption "Gaming";
    misc.enable = lib.mkEnableOption "Misc gaming Apps";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      gaming = {
        emulators.enable = lib.mkDefault true;
        discord.enable = lib.mkDefault true;
        gamemode.enable = lib.mkDefault true;
        heroic.enable = lib.mkDefault true;
        mangohud.enable = lib.mkDefault true;
        steam.enable = lib.mkDefault true;
        misc.enable = true;
      };
    })

    {
      home-manager.users.${username}.home.packages = lib.optionals cfg.misc.enable (
        with pkgs;
        [
          wineWowPackages.waylandFull
          bottles
          prismlauncher
          steam-run
          ludusavi
        ]
      );
    }

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories = lib.optionals cfg.misc.enable (
        [ "ludusavi-backup" ]
        ++ (map (p: ".local/share/${p}") [
          "ATLauncher"
          "bottles"
          "PrismLauncher"
        ])
      );
    })
  ];
}

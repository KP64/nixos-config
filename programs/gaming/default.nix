{
  pkgs,
  lib,
  config,
  username,
  ...
}:

{
  imports = [
    ./emulators

    ./discord.nix
    ./gamemode.nix
    ./heroic.nix
    ./mangohud.nix
    ./steam.nix
  ];

  options.gaming.defaults.enable = lib.mkEnableOption "Enables Some gaming Apps";

  config = lib.mkIf config.gaming.defaults.enable {
    home-manager.users.${username}.home.packages = with pkgs; [
      wineWowPackages.waylandFull
      bottles
      atlauncher
      steam-run
      openarena
    ];
    environment.persistence."/persist".users.${username}.directories = [
      ".local/share/ATLauncher"
      ".local/share/bottles"
    ];
  };
}

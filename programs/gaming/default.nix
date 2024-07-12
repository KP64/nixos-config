{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:

let
  stable-pkgs = inputs.stable-nixpkgs.legacyPackages.${pkgs.system};
in
{
  imports = [
    ./gamemode.nix
    ./heroic.nix
    ./mangohud.nix
    ./steam.nix
  ];

  options.gaming.enable = lib.mkEnableOption "Enables Some gaming Apps";

  config = lib.mkIf config.gaming.enable {
    # TODO: Check wether opening for dolphin is really needed
    networking.firewall = {
      allowedTCPPorts = [ 5000 ];
      allowedUDPPorts = [ 5000 ];
    };
    home-manager.users.${username}.home.packages =
      with pkgs;
      [
        discord

        wineWowPackages.waylandFull
        ryujinx
        xemu

        atlauncher
        steam-run
        openarena
      ]
      ++ [ stable-pkgs.dolphin-emu ];
  };
}

{ config, ... }:
let
  nix.settings = {
    substituters = [ "https://nixos-raspberrypi.cachix.org" ];

    trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };
in
{
  flake.aspects.rpi-cache = {
    nixos = {
      inherit nix;

      home-manager.sharedModules = [ config.flake.modules.homeManager.rpi-cache ];
    };
    homeManager = { inherit nix; };
  };
}

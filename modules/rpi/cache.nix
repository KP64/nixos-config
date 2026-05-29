let
  nix.settings = {
    substituters = [ "https://nixos-raspberrypi.cachix.org" ];

    trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };
in
{
  den.aspects.rpi-cache = {
    nixos = { inherit nix; };
    homeManager =
      {
        lib,
        osConfig ? null,
        ...
      }:
      lib.mkIf (osConfig == null) { inherit nix; };
  };
}

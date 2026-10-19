{
  # TODO: Figure out btrfs on pis to use impermanence!
  flake-file.inputs.nixos-raspberrypi = {
    type = "github";
    owner = "nvmd";
    repo = "nixos-raspberrypi";
    inputs = {
      flake-compat.follows = "";
      nixpkgs.follows = "nixpkgs";
    };
  };
  den.default =
    let
      nix.settings = {
        substituters = [ "https://nixos-raspberrypi.cachix.org" ];

        trusted-public-keys = [
          "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
        ];
      };
    in
    {
      nixos = { inherit nix; };
      homeManager =
        {
          lib,
          nixosConfig ? null,
          ...
        }:
        lib.mkIf (nixosConfig == null) { inherit nix; };
    };
}

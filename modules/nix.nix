let
  commonSettings = pkgs: {
    package = pkgs.nixVersions.latest;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "no-url-literals"
        "pipe-operators"
      ];
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      trusted-users = [ "@wheel" ];
    };
  };
in
{

  flake.modules = {
    nixos.nix =
      { pkgs, ... }:
      {
        nix = (commonSettings pkgs) // {
          optimise.automatic = true;
          channel.enable = false;
        };
      };

    homeManager.nix =
      { config, pkgs, ... }:
      {
        nix = commonSettings pkgs;

        programs.nh = {
          enable = true;
          clean = {
            enable = true;
            extraArgs = "--keep 5";
          };
          flake = /home/${config.home.homeDirectory}/nixos-config;
        };
      };
  };
}

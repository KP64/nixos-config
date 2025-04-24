{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  nix = {
    package = pkgs.nixVersions.latest;
    optimise.automatic = true;
    registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs;
    channel.enable = false;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "no-url-literals"
        "pipe-operators"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://numtide.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      trusted-users = [ "@wheel" ];
    };
  };

  programs.nix-ld.enable = true;
}

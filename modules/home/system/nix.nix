{
  pkgs,
  inputs,
  rootPath,
  ...
}:
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  home.packages =
    [ inputs.nix-alien.packages.${pkgs.system}.nix-alien ]
    ++ (with pkgs; [
      cachix
      nix-health
      nix-melt
      nix-output-monitor
      nix-tree
      nixpkgs-lint-community
      nixpkgs-review
      nurl
      nvd
      vulnix
    ]);

  programs = {
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    nix-init.enable = true;
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
    nh = {
      enable = true;
      clean.enable = true;
      flake = rootPath;
    };
  };
}

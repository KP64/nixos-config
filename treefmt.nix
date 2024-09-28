{
  # Used to find the project root
  projectRootFile = "flake.nix";

  programs = {
    deadnix.enable = true;
    just.enable = true;
    nixfmt.enable = true;
    prettier = {
      enable = true;
      excludes = [ "*secrets.yaml" ];
    };
    shfmt.enable = true;
    statix.enable = true;
    taplo.enable = true;
    toml-sort.enable = true;
  };
}

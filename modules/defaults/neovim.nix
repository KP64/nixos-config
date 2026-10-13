{ inputs, ... }: {
  flake-file.inputs = {
    neovim-nightly-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "neovim-nightly-overlay";
    };
    nixvim = {
      type = "github";
      owner = "nix-community";
      repo = "nixvim";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  imports = [ inputs.nixvim.flakeModules.default ];

  nixvim = {
    packages.enable = true;
    checks.enable = true;
  };
}

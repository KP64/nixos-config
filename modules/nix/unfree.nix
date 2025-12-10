toplevel:
let
  options.allowedUnfreePackages = toplevel.lib.mkOption {
    default = [ ];
    type = with toplevel.lib.types; listOf nonEmptyStr;
    description = "A list of allowed unfree packages";
    example = [ "terraform" ];
  };
in
{
  flake.modules = {
    nixos.nix-unfree =
      { config, lib, ... }:
      {
        inherit options;

        config = {
          # NOTE: Do not remove this. It is necessary for building user hm
          #       modules in NixOS that would otherwise miss the option.
          home-manager.sharedModules = [ toplevel.config.flake.modules.homeManager.nix-unfree ];

          nixpkgs.config.allowUnfreePredicate =
            pkg: builtins.elem (lib.getName pkg) config.allowedUnfreePackages;
        };
      };

    homeManager.nix-unfree =
      { config, lib, ... }:
      {
        inherit options;

        config.nixpkgs.config.allowUnfreePredicate =
          pkg: builtins.elem (lib.getName pkg) config.allowedUnfreePackages;
      };
  };
}

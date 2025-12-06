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
    nixos.nix =
      { config, lib, ... }:
      {
        inherit options;

        config.nixpkgs.config.allowUnfreePredicate =
          pkg: builtins.elem (lib.getName pkg) config.allowedUnfreePackages;
      };

    homeManager.nix =
      {
        osConfig ? null,
        config,
        lib,
        ...
      }:
      {
        inherit options;

        config = lib.mkIf (osConfig == null) {
          nixpkgs.config.allowUnfreePredicate =
            pkg: builtins.elem (lib.getName pkg) config.allowedUnfreePackages;
        };
      };
  };
}

{ inputs, ... }:
{
  flake.modules.nixos.customLib = {
    imports = [ inputs.nlib.nixosModules.default ];

    nlib.enable = true;
  };
}

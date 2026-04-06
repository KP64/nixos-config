{ lib, ... }:
{
  options.additionalHosts = lib.mkOption {
    default = { };
    type = with lib.types; attrsOf (attrsOf anything);
    description = "Attrs of host and the corresponding system";
  };

  # Ensure modules and networkName are present.
  # Modules are imported in homes generation.
  # networkName is needed for pkg activation on a per host basis.
  config.additionalHosts = builtins.mapAttrs (n: v: { modules = [ ]; } // v // { networkName = n; }) {
    sindbad = {
      system = "x86_64-linux";
      modules = [ { targets.genericLinux.enable = true; } ];
    };
  };
}

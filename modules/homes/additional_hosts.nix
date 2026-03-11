{ lib, ... }:
{
  options.additionalHosts = lib.mkOption {
    default = { };
    type = with lib.types; attrsOf (attrsOf nonEmptyStr);
    description = "Attrs of host and the corresponding system";
  };

  # networkName seems redundant but is needed for easy access
  # when enabling per host packages.
  config.additionalHosts = builtins.mapAttrs (n: v: v // { networkName = n; }) {
    sindbad.system = "x86_64-linux";
  };
}

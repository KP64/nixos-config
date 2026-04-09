{
  # This module only exists because there is no easy
  # way to extract the IP Address of a host
  flake.modules.nixos.ip =
    { lib, ... }:
    {
      # TODO: Find a way to not have to hardcode the values.
      #       Would allow the usage of rotating IPs (e.g. temporary ULAs)
      options = {
        staticIPv4 = lib.mkOption {
          readOnly = true;
          type = lib.types.nonEmptyStr;
          example = "192.168.2.204";
          description = "The static IPv4 Address of the machine";
        };
        # TODO: Disallow null once other hosts are ready
        staticIPv6 = lib.mkOption {
          default = null;
          type = with lib.types; nullOr nonEmptyStr;
          example = "fdef:fa6a:4724:1:56b0:de23:1635:e77f";
          description = "The stable ULA of the machine";
        };
      };
    };
}

{
  # This module only exists because there is no easy
  # way to extract the IP Address of a host
  flake.modules.nixos.ip =
    { lib, ... }:
    {
      options.staticIPv4 = lib.mkOption {
        readOnly = true;
        type = lib.types.nonEmptyStr;
        example = "192.168.2.204";
        description = "The static IPv4 Address of the machine";
      };
    };
}

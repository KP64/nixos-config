{
  den.aspects.ip.nixos = { lib, ... }: {
    options = {
      staticIPv4 = lib.mkOption {
        readOnly = true;
        type = lib.types.nonEmptyStr;
        example = "192.168.2.204";
        description = "The static IPv4 Address of the machine";
      };
      staticIPv6 = lib.mkOption {
        readOnly = true;
        type = lib.types.nonEmptyStr;
        example = "fdef:fa6a:4724:1:56b0:de23:1635:e77f";
        description = "A random static IPv6 in the ULA Range";
      };
    };
  };
}

{
  # TODO: Move this to servers only.
  #         -> Aladdin & Sindbad shouldn't need to set this.
  # den.default = { host, ... }: { includes = lib.optional host.isServer den.aspects.static-ip; };
  den.aspects.static-ip = { lib, ... }: {
    settings = {
      v4 = lib.mkOption {
        default = null;
        type = with lib.types; nullOr nonEmptyStr;
        example = "192.168.178.201";
        description = "A random static IPv4 in the private range";
      };
      v6 = lib.mkOption {
        readOnly = true;
        type = lib.types.nonEmptyStr;
        example = "fdef:fa6a:4724:1:56b0:de23:1635:e77f";
        description = "A random static IPv6 in the ULA Range";
      };
    };
  };
}

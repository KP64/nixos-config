{
  den.default.nixos =
    { host, lib, ... }:
    lib.optionalAttrs (!host.isServer) {
      security.polkit.enable = true;

      location.provider = "geoclue2";
      services.automatic-timezoned.enable = true;
    };
}

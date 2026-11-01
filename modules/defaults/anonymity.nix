{
  den.default.nixos =
    { host, lib, ... }:
    lib.optionalAttrs (!host.isServer) {
      systemd.coredump.enable = false;
      services.journald.settings.Journal.Storage = "volatile";
    };
}

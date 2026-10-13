{
  den.default.nixos = {
    systemd.coredump.enable = false;
    services.journald.settings.Journal.Storage = "volatile";
  };
}

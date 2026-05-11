{
  flake.modules.nixos.auto-timezone = {
    security.polkit.enable = true;

    location.provider = "geoclue2";
    services.automatic-timezoned.enable = true;
  };
}

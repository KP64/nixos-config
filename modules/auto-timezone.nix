{
  den.aspects.auto-timezone.nixos = {
    security.polkit.enable = true;

    location.provider = "geoclue2";
    services.automatic-timezoned.enable = true;
  };
}

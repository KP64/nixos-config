{
  config,
  lib,
  invisible,
  ...
}:
let
  cfg = config.services.networking.tor;
in
{
  options.services.networking.tor.enable = lib.mkEnableOption "Tor";

  config.services = lib.mkIf cfg.enable {
    snowflake-proxy = {
      enable = true;
      capacity = 20;
    };

    tor = {
      enable = true;
      openFirewall = true;
      settings.ContactInfo = invisible.email;
      relay = {
        enable = true;
        role = "relay";
      };
    };
  };
}

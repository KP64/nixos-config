{
  config,
  lib,
  invisible,
  ...
}:
let
  # TODO: Provide Secret Key to All tor onion Services.
  # This improves reproducibility as the generated onion links
  # will always be the same
  cfg = config.services.networking.tor;
in
{
  options.services.networking.tor.enable = lib.mkEnableOption "Tor";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services = {
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
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories =
        lib.optional cfg.enable config.services.tor.settings.DataDirectory;
    })
  ];
}

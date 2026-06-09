{ den, ... }: {
  den.aspects.zarqa = {
    includes = [ den.aspects.secrets._.porkbun ];

    nixos = { config, ... }: {
      sops.secrets =
        let
          restartUnits = [ config.systemd.services.oink.name ];
        in
        {
          "porkbun/api_key" = { inherit restartUnits; };
          "porkbun/secret_api_key" = { inherit restartUnits; };
        };

      services.oink = {
        enable = true;
        apiKeyFile = config.sops.secrets."porkbun/api_key".path;
        secretApiKeyFile = config.sops.secrets."porkbun/secret_api_key".path;
        settings.interval = 300;
        domains = [
          { inherit (config.networking) domain; }
          {
            inherit (config.networking) domain;
            subdomain = "*";
          }
        ];
      };
    };
  };
}

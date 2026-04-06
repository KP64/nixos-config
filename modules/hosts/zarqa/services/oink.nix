{
  flake.modules.nixos.hosts-zarqa =
    { config, ... }:
    {
      sops.secrets = {
        "porkbun/api_key" = { };
        "porkbun/secret_api_key" = { };
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
}

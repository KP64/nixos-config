{ self, ... }: {
  den.aspects.zarqa.nixos = { config, lib, ... }: {
    sops.secrets =
      let
        sopsFile = "${self}/secrets/porkbun.yaml";
        restartUnits = [ config.systemd.services.oink.name ];
      in
      lib.mkIf config.services.oink.enable {
        porkbun_api_key = {
          inherit sopsFile restartUnits;
          key = "api_key";
        };
        porkbun_secret_api_key = {
          inherit sopsFile restartUnits;
          key = "secret_api_key";
        };
      };

    services.oink = {
      enable = true;
      apiKeyFile = config.sops.secrets.porkbun_api_key.path;
      secretApiKeyFile = config.sops.secrets.porkbun_secret_api_key.path;
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

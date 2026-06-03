{ self, ... }: {
  den.aspects.mahdi.nixos = { config, ... }: {
    sops.secrets =
      let
        owner = config.users.users.acme.name;
        sopsFile = "${self}/secrets/porkbun.yaml";
      in
      {
        porkbun_api_key = {
          inherit sopsFile owner;
          key = "api_key";
        };
        porkbun_secret_api_key = {
          inherit sopsFile owner;
          key = "secret_api_key";
        };
      };

    security.acme = {
      acceptTerms = true;
      defaults = {
        inherit (config.invisible) email;
        dnsProvider = "porkbun";
        credentialFiles =
          let
            inherit (config.sops) secrets;
          in
          {
            PORKBUN_API_KEY_FILE = secrets.porkbun_api_key.path;
            PORKBUN_SECRET_API_KEY_FILE = secrets.porkbun_secret_api_key.path;
          };
      };
    };
  };
}

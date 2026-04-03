{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      sops.secrets =
        let
          owner = config.users.users.acme.name;
        in
        {
          "porkbun/api_key" = { inherit owner; };
          "porkbun/secret_api_key" = { inherit owner; };
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
              PORKBUN_API_KEY_FILE = secrets."porkbun/api_key".path;
              PORKBUN_SECRET_API_KEY_FILE = secrets."porkbun/secret_api_key".path;
            };
        };
      };
    };
}

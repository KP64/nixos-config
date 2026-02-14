{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      sops.secrets =
        let
          owner = config.users.users.acme.name;
        in
        {
          "rfc2136/nameserver" = { inherit owner; };
          "rfc2136/tsig_algorithm" = { inherit owner; };
          "rfc2136/tsig_key" = { inherit owner; };
          "rfc2136/tsig_secret" = { inherit owner; };
        };

      # TODO: Use security.acme.certs.<name>.reloadServices (same kind of the sops todo)
      security.acme = {
        acceptTerms = true;
        defaults = {
          inherit (config.invisible) email;
          dnsResolver = "1.1.1.1:53";
          dnsProvider = "rfc2136";
          credentialFiles =
            let
              inherit (config.sops) secrets;
            in
            {
              RFC2136_NAMESERVER_FILE = secrets."rfc2136/nameserver".path;
              RFC2136_TSIG_ALGORITHM_FILE = secrets."rfc2136/tsig_algorithm".path;
              RFC2136_TSIG_KEY_FILE = secrets."rfc2136/tsig_key".path;
              RFC2136_TSIG_SECRET_FILE = secrets."rfc2136/tsig_secret".path;
            };
        };
      };
    };
}

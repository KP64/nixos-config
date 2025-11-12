{
  flake.modules.nixos.hosts-mahdi = {
    # services.nginx.virtualHosts."scrutiny.${config.networking.domain}" = {
    #   enableACME = true;
    #   acmeRoot = null;
    #   onlySSL = true;
    #   kTLS = true;
    #   locations."/" = {
    #     proxyPass = config.services.scrutiny.settings.api.endpoint;
    #   };
    # };

    services.scrutiny = {
      enable = true;
      openFirewall = true;
      settings = {
        web.listen.port = 44617;
      };
    };
  };
}

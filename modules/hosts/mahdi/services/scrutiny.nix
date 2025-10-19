{
  # TODO: Let this be public once kanidm works
  flake.modules.nixos.hosts-mahdi = {
    # services.nginx.virtualHosts."scrutiny.${config.networking.domain}" = {
    #   enableACME = true;
    #   acmeRoot = null;
    #   onlySSL = true;
    #   kTLS = true;
    #   locations."/" = {
    #     proxyPass = "http://localhost:${toString config.services.scrutiny.settings.web.listen.port}";
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

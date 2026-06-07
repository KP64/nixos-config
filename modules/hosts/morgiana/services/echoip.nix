{
  den.aspects.morgiana.nixos = { config, lib, ... }: {
    services = {
      caddy.virtualHosts."echoip.${config.networking.domain}" = lib.mkIf config.services.echoip.enable {
        extraConfig = # caddy
          ''
            reverse_proxy http://${config.services.echoip.listenAddress}
          '';
      };

      echoip = {
        enable = true;
        listenAddress = "[::1]:8000";
        enablePortLookup = true;
        enableReverseHostnameLookups = true;
        remoteIpHeader = "X-Forwarded-For";
      };
    };
  };
}

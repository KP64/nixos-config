toplevel:
let
  inherit (toplevel.config.flake.nixosConfigurations) mahdi morgiana;
  forgejoSSHPort = mahdi.config.services.forgejo.settings.server.SSH_PORT;
  inherit (mahdi.config.services.opengist.environment) OG_SSH_PORT;
  ntsPort = 4460;
  minecraftPort = 25565;
in
{
  # TODO: Find a better way for HAProxy
  den.aspects.sheherazade.nixos = {
    networking.firewall.allowedTCPPorts = [
      ntsPort
      forgejoSSHPort
      OG_SSH_PORT
      minecraftPort
    ];

    services.haproxy = {
      enable = true;
      config = ''
        global
          ssl-mode-async
          zero-warning

          harden.reject-privileged-ports.tcp on
          harden.reject-privileged-ports.quic on

          httpclient.ssl.verify required
          ssl-default-bind-options force-tlsv13

        defaults
          mode tcp

          option clitcpka
          option srvtcpka

          timeout connect 10s
          timeout client 1h
          timeout server 1h

        frontend nts-in
          bind [::]:${toString ntsPort} v4v6
          timeout client 30s
          default_backend nts-out
        backend nts-out
          timeout server 30s
          server nts [${morgiana.config.staticIPv6}]:${toString ntsPort} check

        frontend forgejo-in
          bind [::]:${toString forgejoSSHPort} v4v6
          timeout client 5m
          default_backend forgejo-out
        backend forgejo-out
          timeout server 5m
          timeout tunnel 5m
          server forgejo [${mahdi.config.staticIPv6}]:${toString forgejoSSHPort} check

        frontend opengist-in
          bind [::]:${toString OG_SSH_PORT} v4v6
          timeout client 5m
          default_backend opengist-out
        backend opengist-out
          timeout server 5m
          timeout tunnel 5m
          server opengist [${mahdi.config.staticIPv6}]:${toString OG_SSH_PORT} check

        frontend minecraft-in
          bind [::]:${toString minecraftPort} v4v6
          timeout client 24h
          default_backend minecraft-out
        backend minecraft-out
          timeout server 24h
          timeout tunnel 24h
          server minecraft [${mahdi.config.staticIPv6}]:${toString minecraftPort} check
      '';
    };
  };
}

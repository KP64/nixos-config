{
  # TODO: Finish Setup
  flake.modules.nixos.hosts-mahdi =
    { config, pkgs, ... }:
    {
      services.nginx.virtualHosts."forgejo.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}";
        };
      };

      networking.firewall.allowedTCPPorts = [ config.services.forgejo.settings.server.SSH_PORT ];

      # FIXME: https://github.com/catppuccin/nix/issues/721
      catppuccin.forgejo.enable = false;

      services.forgejo = {
        enable = true;
        package = pkgs.forgejo; # Newest version ;)
        lfs.enable = true;
        dump.enable = true;
        # database.passwordFile = "";
        # secrets = { };
        settings = {
          server = {
            HTTP_PORT = 36031;
            PROTOCOL = "http+unix";
            DOMAIN = "forgejo.${config.networking.domain}";
            ROOT_URL = "https://${config.services.forgejo.settings.server.DOMAIN}";

            START_SSH_SERVER = true; # Needed because isn't started by default.
            SSH_PORT = 2222; # High port so that forgejo user can bind to it ;)
          };
          repository.DISABLE_HTTP_GIT = true;
          security = {
            PASSWORD_COMPLEXITY = "lower,upper,digit,spec";
            PASSWORD_CHECK_PWN = true;
          };
          session.COOKIE_SECURE = true;
          service.ENABLE_CAPTCHA = true;
        };
      };

      # NOTE: Either podman or Docker needed for runners
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        autoPrune.enable = true;
      };
      services.gitea-actions-runner = {
        package = pkgs.forgejo-runner;
        instances = { };
      };
    };
}

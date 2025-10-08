{
  # TODO: Finish Setup
  flake.modules.nixos.hosts-mahdi =
    { config, pkgs, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        routers.forgejo = {
          rule = "Host(`forgejo.${config.networking.domain}`)";
          service = "forgejo";
        };
        services.forgejo.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.forgejo.settings.server.HTTP_PORT}"; }
        ];
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
          server = rec {
            START_SSH_SERVER = true; # Needed because isn't started by default.
            SSH_PORT = 36032; # High port so that forgejo user can bind to it ;)
            # TODO: The "forgejo" subdomain is NOT needed. Fix that?
            DOMAIN = "forgejo.${config.networking.domain}";
            ROOT_URL = "https://${DOMAIN}";
            HTTP_PORT = 36031;
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

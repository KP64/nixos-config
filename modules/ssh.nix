{
  flake.modules = {
    nixos.ssh = {
      programs.ssh.startAgent = true;

      services.openssh = {
        enable = true;
        startWhenNeeded = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
        extraConfig = ''
          # NOTE: Hardening Setting Recommended by ssh-audit
          # Number of unauthenticated connections allowed from a given source address.
          PerSourceMaxStartups 1
        '';
      };
    };

    homeManager.ssh =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.openssh ];

        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
        };

        services.ssh-agent.enable = true;
      };
  };
}

{
  flake.aspects.ssh = {
    nixos = {
      services.openssh = {
        enable = true;
        startWhenNeeded = true;
        # Only trust users.users.<name>.openssh.authorizedKeys.*
        authorizedKeysInHomedir = false;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };
    };

    homeManager =
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

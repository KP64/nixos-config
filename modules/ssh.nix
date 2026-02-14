{
  flake.modules = {
    nixos.ssh = {
      services.openssh = {
        enable = true;
        startWhenNeeded = true;
        # Only trust users.users.<name>.openssh.authorizedKeys.keys
        authorizedKeysInHomedir = false;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
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

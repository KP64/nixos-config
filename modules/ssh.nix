{
  flake.modules = {
    nixos.ssh = {
      services.openssh = {
        enable = true;
        startWhenNeeded = true;
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

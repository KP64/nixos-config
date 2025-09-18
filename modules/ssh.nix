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
      };
    };

    homeManager.ssh = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
      };

      services = {
        ssh-agent.enable = true;
        ssh-tpm-agent.enable = true;
      };
    };
  };
}

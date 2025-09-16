{
  flake.modules = {
    nixos.ssh = {
      programs.ssh.startAgent = true;

      services.openssh = {
        enable = true;
        startWhenNeeded = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };
    };

    homeManager.ssh = {
      # TODO: Configure
      programs.ssh = {
        enable = true;
        # TODO: Remove when unused upstream
        enableDefaultConfig = false;
      };

      services = {
        ssh-agent.enable = true;
        ssh-tpm-agent.enable = true;
      };
    };
  };
}

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
      { osConfig, ... }:
      {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
        };

        services = {
          ssh-agent.enable = true;
          # TODO: Use different logic, if doesn't work correctly for HomeConfigurations later on
          # This agent is only for TPM >= v2.0
          ssh-tpm-agent.enable = osConfig.security.tpm2.enable;
          # TODO: Implement yubikey agent logic
        };
      };
  };
}

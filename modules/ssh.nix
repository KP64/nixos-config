{
  flake.modules = {
    nixos.ssh = {
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

    homeManager.ssh =
      {
        config,
        osConfig ? null,
        pkgs,
        ...
      }:
      {
        home.packages = [ pkgs.openssh ];

        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
        };

        services = {
          ssh-agent.enable = true;
          ssh-tpm-agent.enable =
            let
              inherit (osConfig.security) tpm2;
              groups = osConfig.users.users.${config.home.username}.extraGroups;
            in
            (osConfig != null) && tpm2.enable && (builtins.elem tpm2.tssGroup groups);
        };
      };
  };
}

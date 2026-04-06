{
  flake.modules = {
    nixos.ssh = {
      # TODO: Add a banner
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

      # TODO: Temporary. Remove once confident in the Security aspect.
      services.fail2ban = {
        enable = true;
        ignoreIP = [ "192.168.2.0/24" ];
        bantime-increment = {
          enable = true;
          rndtime = "10m";
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

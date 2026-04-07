{
  flake.modules = {
    nixos.ssh = {
      services.openssh = {
        enable = true;
        startWhenNeeded = true;
        # Only trust users.users.<name>.openssh.authorizedKeys.*
        authorizedKeysInHomedir = false;
        banner = ''
          Unauthorized connection is disallowed.
          This connection may be monitored.
          Even then I can't stop you since you've come so far ¯\_(ツ)_/¯.
          Although you are most likely an adversary I can only
          ask you to be a bro and disclose how you got in after
          you've finished with your shenanigans X).
        '';
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

{
  den.aspects.ssh = {
    nixos = { pkgs, ... }: {
      services.openssh = {
        enable = true;
        startWhenNeeded = true;
        # Only trust users.users.<name>.openssh.authorizedKeys.*
        authorizedKeysInHomedir = false;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          Banner = toString (
            pkgs.writeTextFile {
              name = "ssh_banner";
              text = ''
                Unauthorized connection is disallowed.
                This connection may be monitored.
                Although you are most likely an adversary I can only
                ask you to be a bro and disclose how you got in after
                you've finished with your shenanigans X).
              '';
            }
          );
        };
      };

      # TODO: Replace with crowdsec
      services.fail2ban = {
        enable = true;
        bantime-increment = {
          enable = true;
          rndtime = "10m";
        };
      };
    };

    homeManager = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
      };

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
      };
    };
  };
}

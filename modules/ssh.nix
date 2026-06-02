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
                Even then I can't stop you since you've come so far ¯\_(ツ)_/¯.
                Although you are most likely an adversary I can only
                ask you to be a bro and disclose how you got in after
                you've finished with your shenanigans X).
              '';
            }
          );
        };
      };

      # TODO: Temporary. Remove once confident in the Security aspect.
      services.fail2ban = {
        enable = true;
        ignoreIP = [
          "192.168.2.0/24"
          "fdef:fa6a:4724:1::/64"
        ];
        bantime-increment = {
          enable = true;
          rndtime = "10m";
        };
      };
    };

    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.openssh ];

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
      };

      services.ssh-agent.enable = true;
    };
  };
}

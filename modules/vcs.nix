{ den, ... }: {
  den.aspects.vcs = {
    homeManager = { lib, ... }: {
      options.vcs.user = {
        name = lib.mkOption {
          readOnly = true;
          description = "Your Git Username";
          type = lib.types.nonEmptyStr;
          example = "alice";
        };
        email = lib.mkOption {
          readOnly = true;
          description = "Your Git Email";
          type = lib.types.nonEmptyStr;
          example = "example@gmail.com";
        };
      };
    };

    _ = {
      git = {
        includes = [ den.aspects.vcs ];

        homeManager = { config, ... }: {
          programs = {
            git-cliff.enable = true;
            gitui.enable = true;
            git =
              let
                sshDir = "${config.home.homeDirectory}/.ssh";
              in
              {
                enable = true;
                lfs.enable = true;
                settings = {
                  inherit (config.vcs) user;
                  init.defaultBranch = "main";
                  gpg.ssh.allowedSignersFile = "${sshDir}/allowed_signers";
                };
                signing = {
                  signByDefault = true;
                  format = "ssh";
                  key = "${sshDir}/id_ed25519.pub";
                };
              };
          };
        };
      };

      jujutsu = {
        includes = [ den.aspects.vcs ];

        homeManager = { config, ... }: {
          programs = {
            jjui.enable = true;
            jujutsu = {
              enable = true;
              settings =
                let
                  sshDir = "${config.home.homeDirectory}/.ssh";
                in
                {
                  inherit (config.vcs) user;
                  ui.default-command = [ "log" ];
                  signing = {
                    behavior = "own";
                    backend = "ssh";
                    key = "${sshDir}/id_ed25519.pub";
                    backends.ssh.allowed-signers = "${sshDir}/allowed_signers";
                  };
                };
            };
          };
        };
      };
    };
  };
}

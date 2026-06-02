{
  # TODO: Git and jj aspects
  den.aspects.vcs.homeManager = { config, lib, ... }: {
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

    config.programs = {
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

      jjui.enable = true;
      jujutsu =
        let
          inherit (config.programs) git;
        in
        {
          enable = true;
          settings = {
            inherit (git.settings) user;
            ui.default-command = [ "log" ];
            signing = {
              behavior = "own";
              backend = "ssh";
              inherit (git.signing) key;
              backends.ssh.allowed-signers = git.settings.gpg.ssh.allowedSignersFile;
            };
          };
        };
    };
  };
}

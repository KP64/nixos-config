{
  flake.modules.homeManager.vcs =
    { config, lib, ... }:
    {
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
        gh = {
          enable = true;
          settings.git_protocol = "ssh";
        };
        gh-dash.enable = true;

        git-cliff.enable = true;

        gitui.enable = true;
        git =
          let
            inherit (config.vcs) user;
          in
          {
            enable = true;
            lfs.enable = true;
            userName = user.name;
            userEmail = user.email;
            delta = {
              enable = true;
              options.line-numbers = true;
            };
            signing = {
              signByDefault = true;
              format = "ssh";
              key = "~/.ssh/id_ed25519.pub";
            };
            extraConfig = {
              init.defaultBranch = "main";
              gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
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
              user = {
                name = git.userName;
                email = git.userEmail;
              };
              ui.default-command = [ "log" ];
              signing = {
                behavior = "own";
                backend = "ssh";
                inherit (git.signing) key;
                backends.ssh.allowed-signers = git.extraConfig.gpg.ssh.allowedSignersFile;
              };
            };
          };
      };
    };
}

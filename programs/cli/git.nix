{
  lib,
  config,
  pkgs,
  username,
  ...
}:

let
  cfg = config.cli.git;
in
{
  options.cli.git = with lib; {
    enable = mkEnableOption "Git & helper Utils";
    user = {
      name = mkOption {
        readOnly = true;
        description = "Your Git Username";
        type = types.nonEmptyStr;
        example = "alice";
      };
      email = mkOption {
        readOnly = true;
        description = "Your Git Email";
        type = types.nonEmptyStr;
        example = "example@gmail.com";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home = {
        packages = with pkgs; [
          git-who
          gfold
          gitoxide
          gitleaks
          gql
          trufflehog
        ];

        file.".ssh/allowed_signers".text = "* ${builtins.readFile ../../hosts/${username}/id_ed25519.pub}";
      };

      programs = {
        gitui.enable = true;

        git-cliff.enable = true;

        jujutsu = {
          enable = true;
          settings = { inherit (cfg) user; };
        };

        git = {
          enable = true;
          lfs.enable = true;
          userName = cfg.user.name;
          userEmail = cfg.user.email;
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
      };
    };
  };
}

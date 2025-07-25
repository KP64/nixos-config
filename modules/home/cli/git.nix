{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.cli.git;
in
{
  options.cli.git = {
    enable = lib.mkEnableOption "Git & helper Utils";
    user = {
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

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gfold
      gitoxide
      gitleaks
      git-who
      gql
      lazyjj
      trufflehog
    ];

    programs =
      let
        key = "~/.ssh/id_ed25519.pub";
        signerPath = "~/.ssh/allowed_signers";
      in
      {
        gh = {
          enable = true;
          settings.git_protocol = "ssh";
        };

        gitui.enable = true;

        git-cliff.enable = true;

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
            inherit key;
          };
          extraConfig = {
            init.defaultBranch = "main";
            gpg.ssh.allowedSignersFile = signerPath;
          };
        };

        jujutsu = {
          enable = true;
          settings = {
            inherit (cfg) user;
            ui.default-command = [ "log" ];
            signing = {
              behavior = "own";
              backend = "ssh";
              inherit key;
              backends.ssh.allowed-signers = signerPath;
            };
          };
        };
      };
  };
}

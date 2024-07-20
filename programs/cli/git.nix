{
  lib,
  config,
  pkgs,
  username,
  ...
}:

let
  cfg = config.programs.cli.git;
in
{
  options.programs.cli.git = {
    enable = lib.mkEnableOption "Enables Git & helper Utils";
    user = {
      name = lib.mkOption {
        description = "Your Git Username";
        type = lib.types.str;
        readOnly = true;
      };
      email = lib.mkOption {
        description = "Your Git Email";
        type = lib.types.str;
        readOnly = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        gitoxide
        gitleaks
      ];

      programs = {
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
          extraConfig.init.defaultBranch = "master";
        };
      };
    };
  };
}

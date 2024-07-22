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
  options.programs.cli.git = with lib; {
    enable = mkEnableOption "Enables Git & helper Utils";
    user = {
      name = mkOption {
        description = "Your Git Username";
        type = types.str;
        readOnly = true;
      };
      email = mkOption {
        description = "Your Git Email";
        type = types.str;
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

{ pkgs, username, ... }:
{
  # TODO: Get name and email out. (Maybe through sops-nix?)
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
        userName = "KP64";
        userEmail = "karamalsadeh@hotmail.com";
        delta = {
          enable = true;
          options.line-numbers = true;
        };
        extraConfig.init.defaultBranch = "master";
      };
    };
  };
}

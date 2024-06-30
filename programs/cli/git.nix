{ username, ... }:
{
  # TODO: Get name and email out. (Maybe through sops-nix?)
  home-manager.users.${username}.programs.git = {
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
}

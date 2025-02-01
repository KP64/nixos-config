{ username, pkgs, ... }:
{
  home-manager.users.${username} = {
    home.packages = [ pkgs.television ];
    programs.fzf.enable = true;
  };
}

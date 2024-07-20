{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = [ pkgs.igrep ];
    programs.ripgrep.enable = true;
  };
}

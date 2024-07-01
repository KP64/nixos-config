{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [ igrep ];
    programs.ripgrep.enable = true;
  };
}

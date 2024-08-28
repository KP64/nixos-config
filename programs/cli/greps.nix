{ stable-pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = [ stable-pkgs.igrep ];
    programs.ripgrep.enable = true;
  };
}

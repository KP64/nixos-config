{ pkgs, username, ... }:
{
  nix.settings = {
    substituters = [ "https://yazi.cachix.org" ];
    trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
  };
  home-manager.users.${username} = {
    home.packages = [ pkgs.exiftool ];
    programs.yazi = {
      enable = true;
      settings.manager.show_hidden = true;
    };
  };
}

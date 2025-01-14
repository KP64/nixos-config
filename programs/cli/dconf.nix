{ lib, username, ... }:
{
  programs.dconf.enable = true;
  home-manager.users.${username}.dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = lib.mkDefault "prefer-dark";
  };
}

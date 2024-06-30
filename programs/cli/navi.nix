{ username, ... }:
{
  home-manager.users.${username}.programs.navi.enable = true;
}

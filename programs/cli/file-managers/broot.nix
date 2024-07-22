{ username, ... }:
{
  home-manager.users.${username}.programs.broot.enable = true;
}

{ username, ... }:
{
  home-manager.users.${username}.programs.bacon.enable = true;
}

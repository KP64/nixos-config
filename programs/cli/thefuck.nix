{ username, ... }:
{
  home-manager.users.${username}.programs.thefuck.enable = true;
}

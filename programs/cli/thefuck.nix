{ username, ... }:
{
  # TODO: Building fails
  home-manager.users.${username}.programs.thefuck.enable = false;
}

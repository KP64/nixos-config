{ username, ... }:
{
  home-manager.users.${username}.programs.git-cliff.enable = true;
}

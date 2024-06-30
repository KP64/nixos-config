{ username, ... }:
{
  home-manager.users.${username}.programs.fastfetch.enable = true;
}

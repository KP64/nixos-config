{ username, ... }:
{
  home-manager.users.${username}.programs.cava.enable = true;
}

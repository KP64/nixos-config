{ username, ... }:
{
  home-manager.users.${username}.programs.ripgrep.enable = true;
}

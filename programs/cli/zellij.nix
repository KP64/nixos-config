{ username, ... }:
{
  home-manager.users.${username}.programs.zellij.enable = true;
}

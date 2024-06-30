{ username, ... }:
{
  home-manager.users.${username}.programs.gitui.enable = true;
}

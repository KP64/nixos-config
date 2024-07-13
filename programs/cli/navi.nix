{ username, ... }:
{
  # TODO: Add some cheatsheets!
  home-manager.users.${username}.programs.navi.enable = true;
}

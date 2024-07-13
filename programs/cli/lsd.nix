{ username, ... }:
{
  home-manager.users.${username}.programs.lsd = {
    enable = true;
    enableAliases = true;
    settings.sorting.dir-grouping = "first";
  };
}

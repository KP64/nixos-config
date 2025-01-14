{ inputs, username, ... }:
{
  home-manager.users.${username}.programs.navi = {
    enable = true;
    settings.cheats.paths = with inputs; [
      navi-papanito-cheats
      navi-denis-cheats
      navi-denis-dotfiles
      navi-denis-tldr-pages
    ];
  };
}

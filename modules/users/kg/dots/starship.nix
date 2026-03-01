{
  flake.modules.homeManager.users-kg-starship = {
    programs.starship = {
      enable = true;
      presets = [ "bracketed-segments" ];
    };
  };
}

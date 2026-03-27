{
  flake.modules.homeManager.users-kg-ttyper = {
    programs.ttyper = {
      enable = true;
      settings.default_language = "rust";
    };
  };
}

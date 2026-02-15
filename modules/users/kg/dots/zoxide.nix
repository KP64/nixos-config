{
  flake.aspects.users-kg-zoxide.homeManager = {
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}

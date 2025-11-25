{
  flake.modules.homeManager.users-kg-zoxide = {
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}

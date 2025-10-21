{
  flake.modules.homeManager.users-kg = {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options.line-numbers = true;
    };
  };
}

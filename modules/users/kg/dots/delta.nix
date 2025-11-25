{
  flake.modules.homeManager.users-kg-delta = {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
      options.line-numbers = true;
    };
  };
}

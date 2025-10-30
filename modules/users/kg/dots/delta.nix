{
  flake.modules.homeManager.users-kg = {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
      options.line-numbers = true;
    };
  };
}

{
  flake.aspects.users-kg-delta.homeManager = {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
      options.line-numbers = true;
    };
  };
}

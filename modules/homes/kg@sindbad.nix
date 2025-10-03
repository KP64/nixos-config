# TODO: That didn't turn out as I thought it would. Change this...
toplevel: {
  flake.modules.homeManager."kg@sindbad" = {
    imports = [ toplevel.config.flake.modules.homeManager.users-kg ];
  };
}

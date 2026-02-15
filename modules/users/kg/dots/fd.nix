{
  flake.aspects.users-kg-fd.homeManager = {
    programs.fd = {
      enable = true;
      hidden = true;
    };
  };
}

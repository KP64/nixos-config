{
  flake.modules.homeManager.users-kg =
    { lib, ... }:
    {
      programs.starship = {
        enable = true;
        settings = lib.importTOML ./bracketed-segments.toml;
      };
    };
}

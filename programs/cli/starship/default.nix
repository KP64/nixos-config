{ lib, username, ... }:
{
  home-manager.users.${username}.programs.starship = {
    enable = true;
    settings = lib.importTOML ./preset.toml;
  };
}

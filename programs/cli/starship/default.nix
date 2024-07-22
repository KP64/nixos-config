{ username, ... }:
{
  home-manager.users.${username}.programs.starship = {
    enable = true;
    settings = fromTOML (builtins.readFile ./preset.toml);
  };
}

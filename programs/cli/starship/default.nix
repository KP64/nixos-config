{ username, ... }:
{
  home-manager.users.${username}.programs.starship = {
    enable = true;
    settings = fromTOML (builtins.readFile ./starship_preset.toml);
  };
}

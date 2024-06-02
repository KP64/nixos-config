{
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./starship_preset.toml);
  };
}

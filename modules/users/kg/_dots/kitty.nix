{ config, lib, ... }:
{
  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
    enableGitIntegration = true;
    settings = {
      shell = lib.mkIf config.programs.nushell.enable "nu";
      background_opacity = 0.9;
    };
  };
}

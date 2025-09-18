{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    enableGitIntegration = true;
    settings = {
      shell = lib.mkIf config.programs.nushell.enable "nu";
      background_opacity = 0.9;
    };
  };
}

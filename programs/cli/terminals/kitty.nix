{
  lib,
  config,
  username,
  ...
}:
{
  options.cli.terminals.kitty.enable = lib.mkEnableOption "Kitty";

  config = lib.mkIf config.cli.terminals.kitty.enable {
    home-manager.users.${username}.programs.kitty = {
      enable = true;
      font.name = lib.mkDefault "JetBrainsMono Nerd Font";
      settings = {
        shell = "nu";
        background_opacity = lib.mkIf config.isCatppuccinEnabled "0.8";
      };
    };
  };
}

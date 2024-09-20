{
  lib,
  config,
  username,
  ...
}:
{

  options.cli.terminals.kitty.enable = lib.mkEnableOption "Enables Kitty";

  config = lib.mkIf config.cli.terminals.kitty.enable {
    home-manager.users.${username}.programs.kitty = {
      enable = true;
      font.name = "JetBrainsMono Nerd Font";
      settings = {
        shell = "nu";
        background_opacity = "0.8";
      };
    };
  };
}

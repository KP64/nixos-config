{
  self,
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  options.editors.neovim.enable = lib.mkEnableOption "Neovim";

  config = lib.mkIf config.editors.neovim.enable {
    home-manager.users.${username}.home.packages = [ self.packages.${pkgs.system}.neovim ];
  };
}

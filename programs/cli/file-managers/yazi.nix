{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.cli.file-managers.yazi.enable = lib.mkEnableOption "Enables Broot";

  config = lib.mkIf config.cli.file-managers.yazi.enable {
    nix.settings = {
      substituters = [ "https://yazi.cachix.org" ];
      trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
    };
    home-manager.users.${username} = {
      home.packages = [ pkgs.exiftool ];
      programs.yazi = {
        enable = true;
        settings.manager.show_hidden = true;
      };
    };
  };
}

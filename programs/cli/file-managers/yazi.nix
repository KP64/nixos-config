{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:
{
  options.cli.file-managers.yazi.enable = lib.mkEnableOption "Yazi";

  config = lib.mkIf config.cli.file-managers.yazi.enable {
    nix.settings = {
      substituters = [ "https://yazi.cachix.org" ];
      trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
    };
    home-manager.users.${username} = {
      home.packages = [ pkgs.exiftool ];
      programs.yazi = {
        enable = true;
        package = inputs.yazi.packages.${pkgs.system}.default;
        settings.manager.show_hidden = true;
      };
    };
  };
}

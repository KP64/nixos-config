{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.desktop.services.copyq.enable = lib.mkEnableOption "Enables Copyq";

  config = lib.mkIf config.desktop.services.copyq.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [ wl-clipboard ];
      services.copyq.enable = true;
    };
  };
}

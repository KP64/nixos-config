{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.apps.enable = lib.mkEnableOption "Enables Some Apps";

  config = lib.mkIf config.apps.enable {
    home-manager.users.${username}.home.packages = with pkgs; [
      gimp
      libreoffice

      hunspell
      hunspellDicts.en_US
      hunspellDicts.de_DE

      whatsapp-for-linux
      aseprite
      figma-linux
    ];
  };
}

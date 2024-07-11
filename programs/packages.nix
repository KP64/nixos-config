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
      figma-linux

      libreoffice
      hunspell
      hunspellDicts.en_US
      hunspellDicts.de_DE

      anki-bin
      whatsapp-for-linux
      simplex-chat-desktop
    ];
  };
}

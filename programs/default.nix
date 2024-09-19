{
  pkgs,
  lib,
  config,
  username,
  ...
}:

{
  imports = [
    ./browsers
    ./cli
    ./editors
    ./gaming
    ./virtualisation

    ./mpv.nix
    ./obs.nix
    ./spicetify.nix
    ./thunderbird.nix
  ];

  options.apps.defaults.enable = lib.mkEnableOption "Enables Some Graphical Apps";

  config = lib.mkIf config.apps.defaults.enable {
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

      czkawka
    ];
  };
}

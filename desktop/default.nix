{
  pkgs,
  lib,
  config,
  username,
  ...
}:

{
  imports = [
    ./eww
    ./hypr
    ./services
    ./login

    ./catppuccin.nix
    ./rofi.nix
    ./waybar.nix
  ];

  options.desktop.enable = lib.mkEnableOption "Enables Desktop Utilities";

  config = lib.mkIf config.desktop.enable {
    home-manager.users.${username}.home.packages = with pkgs; [
      xdg-utils

      # ? Not Tied to mako, as eww could maybe use it too?
      # TODO If yes move it to own module
      libnotify
    ];
  };
}

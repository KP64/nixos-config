{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.browsers.firefox.enable {
  programs.firefox.profiles.i2p = {
    id = 1;
    settings = import ./settings.nix { inherit lib; };
    extensions = {
      force = true;
      packages = with pkgs.nur.repos.rycee.firefox-addons; [
        noscript
        ublock-origin
      ];
    };
  };
}

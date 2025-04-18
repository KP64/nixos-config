{
  config,
  lib,
  pkgs,
  inputs,
  rootPath,
  ...
}:
let
  inherit (config.home) username;
in
lib.mkIf config.browsers.firefox.enable {
  home.file.".mozilla/firefox/${username}/chrome" = {
    source = "${inputs.potato-fox}/chrome/";
    recursive = true;
  };

  programs.firefox.profiles.${username} = {
    extraConfig = builtins.readFile "${inputs.potato-fox}/user.js";

    search = import ./search.nix { inherit lib pkgs rootPath; };

    settings = import ./settings.nix { inherit lib; };

    extensions = {
      force = true;
      packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        catppuccin-web-file-icons
        darkreader
        dearrow
        enhancer-for-youtube
        facebook-container
        firefox-color
        i-dont-care-about-cookies
        indie-wiki-buddy
        languagetool
        libredirect
        private-relay
        refined-github
        return-youtube-dislikes
        sidebery
        simple-translate
        sponsorblock
        stylus
        tabliss
        ublock-origin
        userchrome-toggle-extended
        videospeed
      ];
    };
  };
}

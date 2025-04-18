{
  lib,
  pkgs,
  rootPath,
}:
let
  nixos-icons = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps";

  hideEngines =
    list:
    lib.genAttrs list (_: {
      metaData.hidden = true;
    });
in
rec {
  force = true;
  default = "SearXNG";
  privateDefault = default;
  engines =
    let
      nix-snowflake-icon = "${nixos-icons}/nix-snowflake.svg";

      mkParam = name: value: { inherit name value; };
      nix-search-params = [
        (mkParam "channel" "unstable")
        (mkParam "query" "{searchTerms}")
      ];
    in
    hideEngines [
      "bing"
      "google"
      "ddg"
      "wikipedia"
    ]
    // {
      SearXNG = {
        urls = [
          {
            template = "https://searxng.nix-pi.ipv64.de/search";
            params = [
              (mkParam "q" "{searchTerms}")
              (mkParam "language" "all")
            ];
          }
        ];
        icon = "${rootPath}/assets/firefox/searxng.svg";
        definedAliases = [ "@sx" ];
      };
      "Home Manager" = {
        urls = [
          {
            template = "https://home-manager-options.extranix.com";
            params = [
              (mkParam "query" "{searchTerms}")
              (mkParam "release" "master")
            ];
          }
        ];
        icon = nix-snowflake-icon;
        definedAliases = [ "@hm" ];
      };
      "Nix Packages" = {
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = nix-search-params;
          }
        ];
        icon = nix-snowflake-icon;
        definedAliases = [ "@np" ];
      };
      "Nix Options" = {
        urls = [
          {
            template = "https://search.nixos.org/options";
            params = nix-search-params;
          }
        ];
        icon = nix-snowflake-icon;
        definedAliases = [ "@no" ];
      };
      "NixOS Wiki" = {
        urls = [ { template = "https://wiki.nixos.org/wiki/{searchTerms}"; } ];
        updateInterval = 24 * 60 * 60 * 1000; # every day
        icon = nix-snowflake-icon;
        definedAliases = [ "@nw" ];
      };
    };
}

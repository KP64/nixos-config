{
  lib,
  pkgs,
  inputs,
}:
let
  nixos-icons = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps";
  nix-snowflake-icon = "${nixos-icons}/nix-snowflake.svg";

  mkParam = name: value: { inherit name value; };
  nix-search-params = [
    (mkParam "channel" "unstable")
    (mkParam "query" "{searchTerms}")
  ];

  days = num: num * 1000 * 60 * 60 * 24;
in
{
  force = true;
  default = "duckduckgo";
  privateDefault = "duckduckgo";
  engines =
    lib.custom.hideEngines [
      "bing"
      "ecosia"
      "google"
      "wikipedia"
    ]
    // {
      SearXNG = {
        urls = [
          {
            template = "https://searxng.holab.ipv64.de/search";
            params = [
              (mkParam "q" "{searchTerms}")
              (mkParam "language" "all")
            ];
          }
        ];
        icon = "${inputs.self}/assets/firefox/searxng.svg";
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
        updateInterval = days 1;
        icon = nix-snowflake-icon;
        definedAliases = [ "@nw" ];
      };
    };
}

toplevel@{
  den,
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake-file.inputs = {
    better-fox = {
      type = "github";
      owner = "yokoffing";
      repo = "Betterfox";
      flake = false;
    };
    nur = {
      type = "github";
      owner = "nix-community";
      repo = "nur";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  den.aspects.kg = {
    includes = [
      (den.batteries.unfree [
        "libcublas"
        "libcufft"
        "libcurand"
        "libcusparse"
        "libnpp"
        "libnvjitlink"
        "cudnn"
        "cuda_nvrtc"
      ])
    ];

    _.firefox.homeManager = moduleWithSystem (
      { inputs', ... }:
      { config, lib, ... }:
      let
        inherit (toplevel.config.lib.flake.util) getAsset toFlattenedByDots;
        inherit (toplevel.config.flake.nixosConfigurations) morgiana;
        inherit (config.lib.firefox) hideEngines;
      in
      {
        programs.firefox = {
          enable = true;
          profiles.${config.home.username} = {
            extraConfig = builtins.readFile "${inputs.better-fox}/user.js";

            settings =
              toFlattenedByDots
              <| lib.recursiveUpdate (
                lib.optionalAttrs config.services.glance.enable {
                  browser.startup.homepage = "http://${config.services.glance.settings.server.host}:${toString config.services.glance.settings.server.port}";
                }
              )
              <| {
                network = {
                  trr.mode = 5; # Off by choice -> Uses system DNS resolver
                  proxy.type = 0; # Disable proxy
                };
                # media.peerconnection.enabled = false; # Disable WebRTC -> prevents DNS leakage
                extensions.autoDisableScopes = 0;
                dom.security.https_only_mode = true;
                identity.sync.tokenserver.uri = "${morgiana.config.services.firefox-syncserver.singleNode.url}/1.0/sync/1.5";
                general.autoScroll = true;
                sidebar.verticalTabs = true;
                browser = {
                  newtabpage = {
                    enabled = true;
                    activity-stream = {
                      showSearch = false;
                      showSponsoredCheckboxes = false;
                      showSponsoredTopSites = false;
                      showSponsored = false;
                      feeds = {
                        topsites = false;
                        section = {
                          topstories = false;
                          highlights = false;
                        };
                      };
                    };
                  };
                };
              };

            containersForce = true;
            bookmarks = {
              force = true;
              settings = [
                {
                  name = "ServerlessHorrors";
                  tags = [
                    "horror"
                    "security"
                  ];
                  url = "https://serverlesshorrors.com/";
                }
                {
                  name = "Semantic Scholar";
                  url = "https://www.semanticscholar.org/";
                }
                {
                  name = "Privacy";
                  bookmarks = [
                    {
                      name = "Privacy";
                      url = "https://www.privacy.com/";
                    }
                    {
                      name = "SimpleLogin";
                      url = "https://simplelogin.io/";
                    }
                  ];
                }
                {
                  name = "Rust sites";
                  bookmarks = [
                    {
                      name = "High assurance";
                      url = "https://highassurance.rs/";
                    }
                    {
                      name = "Rustonomicon";
                      url = "https://doc.rust-lang.org/stable/nomicon/";
                    }
                    {
                      name = "Cheats";
                      url = "https://cheats.rs/";
                    }
                    {
                      name = "Corrode";
                      url = "https://corrode.dev/";
                    }
                    {
                      name = "Microslop Rust Training";
                      url = "https://microsoft.github.io/RustTraining";
                    }
                  ];
                }
                {
                  name = "Nix sites";
                  bookmarks = [
                    {
                      name = "Wiki";
                      url = "https://wiki.nixos.org/wiki/NixOS_Wiki";
                    }
                    {
                      name = "Noogle";
                      url = "https://noogle.dev/";
                    }
                    {
                      name = "NixOS and Flakes";
                      url = "https://nixos-and-flakes.thiscute.world/";
                    }
                  ];
                }
              ];
            };

            search = {
              force = true;
              default = "SearXNG";
              privateDefault = "SearXNG";
              engines =
                let
                  nix-icon = getAsset {
                    file = "nix.svg";
                    type = "icons";
                    sha256 = "sha256-gb6sdhBG/YYrJfOPbGWFd1iemWniHF36YsqOwvMH8e4=";
                  };

                  mkParam = name: value: { inherit name value; };
                  nix-search-params = [
                    (mkParam "channel" "unstable")
                    (mkParam "query" "{searchTerms}")
                  ];
                in
                hideEngines [
                  "bing"
                  "ecosia"
                  "google"
                  "wikipedia"
                ]
                // {
                  SearXNG = {
                    urls = [
                      {
                        template = "${morgiana.config.services.searx.settings.server.base_url}/search";
                        params = [
                          (mkParam "q" "{searchTerms}")
                          (mkParam "language" "all")
                        ];
                      }
                    ];
                    icon = getAsset {
                      file = "searxng.svg";
                      type = "icons";
                      sha256 = "sha256-jvs5VUCKZWwkZPRksU7GWc+g+vNSagNX0CRnyaHSng4=";
                    };
                    definedAliases = [ "@sx" ];
                  };
                  "Home Manager" = {
                    urls = [
                      {
                        template = "https://search.nixos.org/options";
                        params = nix-search-params ++ [ (mkParam "source" "home_manager") ];
                      }
                    ];
                    icon = nix-icon;
                    definedAliases = [ "@hm" ];
                  };
                  "Nix Packages" = {
                    urls = [
                      {
                        template = "https://search.nixos.org/packages";
                        params = nix-search-params;
                      }
                    ];
                    icon = nix-icon;
                    definedAliases = [ "@np" ];
                  };
                  "Nix Options" = {
                    urls = [
                      {
                        template = "https://search.nixos.org/options";
                        params = nix-search-params;
                      }
                    ];
                    icon = nix-icon;
                    definedAliases = [ "@no" ];
                  };
                };
            };

            extensions = {
              force = true;
              exactPermissions = true;
              exhaustivePermissions = true;
              packages = with inputs'.nur.legacyPackages.repos.rycee.firefox-addons; [
                bitwarden
                catppuccin-web-file-icons
                darkreader
                dearrow
                facebook-container
                firefox-color
                indie-wiki-buddy
                libredirect
                private-relay
                refined-github
                return-youtube-dislikes
                simple-translate
                sponsorblock
                stylus
                ublock-origin
                videospeed
                vimium
              ];

              settings = {
                "deArrow@ajay.app".permissions = [
                  "storage"
                  "unlimitedStorage"
                  "alarms"
                  "https://sponsor.ajay.app/*"
                  "https://dearrow.ajay.app/*"
                  "https://dearrow-thumb.ajay.app/*"
                  "https://*.googlevideo.com/*"
                  "https://*.youtube.com/*"
                  "https://www.youtube-nocookie.com/embed/*"
                  "scripting"
                ];
                "@contain-facebook".permissions = [
                  "<all_urls>"
                  "browsingData"
                  "contextualIdentities"
                  "cookies"
                  "management"
                  "storage"
                  "tabs"
                  "webRequestBlocking"
                  "webRequest"
                ];
                "FirefoxColor@mozilla.com".permissions = [
                  "theme"
                  "storage"
                  "tabs"
                  "https://color.firefox.com/*"
                ];
                # Stylus
                "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".permissions = [
                  "alarms"
                  "contextMenus"
                  "storage"
                  "tabs"
                  "unlimitedStorage"
                  "webNavigation"
                  "webRequest"
                  "webRequestBlocking"
                  "<all_urls>"
                  "https://userstyles.org/*"
                ];
                "sponsorBlocker@ajay.app".permissions = [
                  "storage"
                  "scripting"
                  "unlimitedStorage"
                  "https://sponsor.ajay.app/*"
                  "https://*.youtube.com/*"
                  "https://www.youtube-nocookie.com/embed/*"
                ];
                # Refined GitHub
                "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}".permissions = [
                  "storage"
                  "scripting"
                  "contextMenus"
                  "activeTab"
                  "alarms"
                  "https://github.com/*"
                  "https://gist.github.com/*"
                ];
                # Return Youtube Dislike
                "{762f9885-5a13-4abd-9c77-433dcd38b8fd}".permissions = [
                  "activeTab"
                  "*://*.youtube.com/*"
                  "storage"
                  "*://returnyoutubedislikeapi.com/*"
                ];
                "simple-translate@sienori".permissions = [
                  "storage"
                  "contextMenus"
                  "http://*/*"
                  "https://*/*"
                  "<all_urls>"
                ];
                # Bitwarden
                "{446900e4-71c2-419f-a6a7-df9c091e268b}".permissions = [
                  "<all_urls>"
                  "*://*/*"
                  "alarms"
                  "clipboardRead"
                  "clipboardWrite"
                  "contextMenus"
                  "idle"
                  "storage"
                  "tabs"
                  "unlimitedStorage"
                  "webNavigation"
                  "webRequest"
                  "webRequestBlocking"
                  "notifications"
                  "file:///*"
                ];
                "7esoorv3@alefvanoon.anonaddy.me" = {
                  settings = lib.importJSON ./libredirect-settings.json;
                  permissions = [
                    "webRequest"
                    "webRequestBlocking"
                    "storage"
                    "clipboardWrite"
                    "contextMenus"
                    "<all_urls>"
                  ];
                };
                "private-relay@firefox.com".permissions = [
                  "<all_urls>"
                  "storage"
                  "menus"
                  "contextMenus"
                  "https://relay.firefox.com/"
                  "https://relay.firefox.com/**"
                  "https://relay.firefox.com/accounts/profile/**"
                  "https://relay.firefox.com/accounts/settings/**"
                ];
                # Video Speed Controller
                "{7be2ba16-0f1e-4d93-9ebc-5164397477a9}".permissions = [
                  "storage"
                  "http://*/*"
                  "https://*/*"
                  "file:///*"
                ];
                # Vimium
                "{d7742d87-e61d-4b78-b8a1-b469842139fa}".permissions = [
                  "tabs"
                  "bookmarks"
                  "history"
                  "storage"
                  "sessions"
                  "notifications"
                  "scripting"
                  "webNavigation"
                  "search"
                  "clipboardRead"
                  "clipboardWrite"
                  "<all_urls>"
                  "file:///"
                  "file:///*/"
                ];
                "addon@darkreader.org".permissions = [
                  "alarms"
                  "contextMenus"
                  "storage"
                  "tabs"
                  "theme"
                  "<all_urls>"
                ];
                # Catppuccin File Explorer Icons
                "{bbb880ce-43c9-47ae-b746-c3e0096c5b76}".permissions = [
                  "storage"
                  "contextMenus"
                  "activeTab"
                  "*://bitbucket.org/*"
                  "*://codeberg.org/*"
                  "*://gitea.com/*"
                  "*://github.com/*"
                  "*://gitlab.com/*"
                  "*://tangled.org/*"
                ];
                "uBlock0@raymondhill.net" = {
                  settings.selectedFilterLists = [
                    "ublock-filters"
                    "ublock-badware"
                    "ublock-privacy"
                    "ublock-quick-fixes"
                    "ublock-unbreak"
                    "easylist"
                    "adguard-generic"
                    "easyprivacy"
                    "adguard-spyware"
                    "adguard-spyware-url"
                    "block-lan"
                    "urlhaus-1"
                    "curben-phishing"
                    "plowe-0"
                    "fanboy-cookiemonster"
                    "ublock-cookies-easylist"
                    "adguard-cookies"
                    "ublock-cookies-adguard"
                  ];
                  permissions = [
                    "alarms"
                    "dns"
                    "menus"
                    "privacy"
                    "storage"
                    "tabs"
                    "unlimitedStorage"
                    "webNavigation"
                    "webRequest"
                    "webRequestBlocking"
                    "<all_urls>"
                    "http://*/*"
                    "https://*/*"
                    "file://*/*"
                    "https://easylist.to/*"
                    "https://*.fanboy.co.nz/*"
                    "https://filterlists.com/*"
                    "https://forums.lanik.us/*"
                    "https://github.com/*"
                    "https://*.github.io/*"
                    "https://github.com/uBlockOrigin/*"
                    "https://ublockorigin.github.io/*"
                    "https://*.reddit.com/r/uBlockOrigin/*"
                  ];
                };
                # Indie Wiki Buddy... WTF...
                "{cb31ec5d-c49a-4e5a-b240-16c767444f62}".permissions = [
                  "storage"
                  "webRequest"
                  "notifications"
                  "scripting"
                  "alarms"
                  "https://*.fandom.com/*"
                  "https://*.fextralife.com/*"
                  "https://*.neoseeker.com/*"
                  "https://breezewiki.com/*"
                  "https://www.google.com/search*"
                ];
              };
            };
          };
        };
      }
    );
  };
}

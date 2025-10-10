toplevel@{ inputs, customLib, ... }:
{
  flake.modules.homeManager.users-kg =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # TODO: Change new tabs and startup to glance
      programs.firefox = {
        enable = true;
        profiles.${config.home.username} = {
          extraConfig = builtins.readFile (inputs.better-fox + /user.js);

          settings = customLib.firefox.toFirefoxSettingStyle {
            network.trr.mode = 5; # Off by choice -> Uses system DNS resolver
            media.peerconnection.enabled = false; # Disable WebRTC -> prevents DNS leakage
            extensions.autoDisableScopes = 0;
            dom.security.https_only_mode = true;
            general.autoScroll = true;
            sidebar.verticalTabs = true;
          };

          search = {
            force = true;
            default = "SearXNG";
            privateDefault = "SearXNG";
            engines =
              let
                inherit (toplevel.config.flake.nixosConfigurations) mahdi;
                nix-snowflake-icon = builtins.path { path = inputs.self + /assets/nix-snowflake.svg; };

                mkParam = name: value: { inherit name value; };
                nix-search-params = [
                  (mkParam "channel" "unstable")
                  (mkParam "query" "{searchTerms}")
                ];
              in
              customLib.firefox.hideEngines [
                "bing"
                "ecosia"
                "google"
                "wikipedia"
              ]
              // {
                SearXNG = {
                  urls = [
                    {
                      template = "${mahdi.config.services.searx.settings.server.base_url}/search";
                      params = [
                        (mkParam "q" "{searchTerms}")
                        (mkParam "language" "all")
                      ];
                    }
                  ];
                  icon = builtins.path { path = inputs.self + /assets/searxng.svg; };
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
              };
          };

          extensions = {
            force = true;
            exactPermissions = true;
            exhaustivePermissions = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              bitwarden
              catppuccin-web-file-icons
              darkreader
              dearrow
              facebook-container
              firefox-color
              indie-wiki-buddy
              libredirect
              private-grammar-checker-harper
              private-relay
              refined-github
              return-youtube-dislikes
              simple-translate
              sponsorblock
              stylus
              tabliss
              ublock-origin
              videospeed
              vimium
            ];

            # Libredirect Settings
            # it's actually a ".js" file, but importing it as JSON is easier :P
            settings = {
              "deArrow@ajay.app".permissions = [
                "storage"
                "unlimitedStorage"
                "alarms"
                "https://sponsor.ajay.app/*"
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
              "extension@tabliss.io".permissions = [ "storage" ];
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
              "harper@writewithharper.com".permissions = [
                "storage"
                "tabs"
                "<all_urls>"
              ];
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
                "*://tangled.sh/*"
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
                "https://*.fandom.com/*"
                "https://*.fextralife.com/*"
                "https://*.neoseeker.com/*"
                "https://breezewiki.com/*"
                "https://antifandom.com/*"
                "https://bw.artemislena.eu/*"
                "https://breezewiki.catsarch.com/*"
                "https://breezewiki.esmailelbob.xyz/*"
                "https://breezewiki.frontendfriendly.xyz/*"
                "https://bw.hamstro.dev/*"
                "https://breeze.hostux.net/*"
                "https://breezewiki.hyperreal.coffee/*"
                "https://breeze.mint.lgbt/*"
                "https://breezewiki.nadeko.net/*"
                "https://nerd.whatever.social/*"
                "https://breeze.nohost.network/*"
                "https://z.opnxng.com/*"
                "https://bw.projectsegfau.lt/*"
                "https://breezewiki.pussthecat.org/*"
                "https://bw.vern.cc/*"
                "https://breeze.whateveritworks.org/*"
                "https://breezewiki.woodland.cafe/*"
                "https://*.bing.com/search*"
                "https://search.brave.com/search*"
                "https://*.duckduckgo.com/*"
                "https://*.ecosia.org/*"
                "https://kagi.com/search*"
                "https://*.qwant.com/*"
                "https://*.search.yahoo.com/*"
                "https://*.startpage.com/*"
                "https://*.ya.ru/*"
                "https://*.yandex.az/*"
                "https://*.yandex.by/*"
                "https://*.yandex.co.il/*"
                "https://*.yandex.com.am/*"
                "https://*.yandex.com.ge/*"
                "https://*.yandex.com.tr/*"
                "https://*.yandex.com/*"
                "https://*.yandex.ee/*"
                "https://*.yandex.eu/*"
                "https://*.yandex.fr/*"
                "https://*.yandex.kz/*"
                "https://*.yandex.lt/*"
                "https://*.yandex.lv/*"
                "https://*.yandex.md/*"
                "https://*.yandex.ru/*"
                "https://*.yandex.tj/*"
                "https://*.yandex.tm/*"
                "https://*.yandex.uz/*"
                "https://www.google.com/search*"
                "https://www.google.ad/search*"
                "https://www.google.ae/search*"
                "https://www.google.com.af/search*"
                "https://www.google.com.ag/search*"
                "https://www.google.com.ai/search*"
                "https://www.google.al/search*"
                "https://www.google.am/search*"
                "https://www.google.co.ao/search*"
                "https://www.google.com.ar/search*"
                "https://www.google.as/search*"
                "https://www.google.at/search*"
                "https://www.google.com.au/search*"
                "https://www.google.az/search*"
                "https://www.google.ba/search*"
                "https://www.google.com.bd/search*"
                "https://www.google.be/search*"
                "https://www.google.bf/search*"
                "https://www.google.bg/search*"
                "https://www.google.com.bh/search*"
                "https://www.google.bi/search*"
                "https://www.google.bj/search*"
                "https://www.google.com.bn/search*"
                "https://www.google.com.bo/search*"
                "https://www.google.com.br/search*"
                "https://www.google.bs/search*"
                "https://www.google.bt/search*"
                "https://www.google.co.bw/search*"
                "https://www.google.by/search*"
                "https://www.google.com.bz/search*"
                "https://www.google.ca/search*"
                "https://www.google.cd/search*"
                "https://www.google.cf/search*"
                "https://www.google.cg/search*"
                "https://www.google.ch/search*"
                "https://www.google.ci/search*"
                "https://www.google.co.ck/search*"
                "https://www.google.cl/search*"
                "https://www.google.cm/search*"
                "https://www.google.cn/search*"
                "https://www.google.com.co/search*"
                "https://www.google.co.cr/search*"
                "https://www.google.com.cu/search*"
                "https://www.google.cv/search*"
                "https://www.google.com.cy/search*"
                "https://www.google.cz/search*"
                "https://www.google.de/search*"
                "https://www.google.dj/search*"
                "https://www.google.dk/search*"
                "https://www.google.dm/search*"
                "https://www.google.com.do/search*"
                "https://www.google.dz/search*"
                "https://www.google.com.ec/search*"
                "https://www.google.ee/search*"
                "https://www.google.com.eg/search*"
                "https://www.google.es/search*"
                "https://www.google.com.et/search*"
                "https://www.google.fi/search*"
                "https://www.google.com.fj/search*"
                "https://www.google.fm/search*"
                "https://www.google.fr/search*"
                "https://www.google.ga/search*"
                "https://www.google.ge/search*"
                "https://www.google.gg/search*"
                "https://www.google.com.gh/search*"
                "https://www.google.com.gi/search*"
                "https://www.google.gl/search*"
                "https://www.google.gm/search*"
                "https://www.google.gr/search*"
                "https://www.google.com.gt/search*"
                "https://www.google.gy/search*"
                "https://www.google.com.hk/search*"
                "https://www.google.hn/search*"
                "https://www.google.hr/search*"
                "https://www.google.ht/search*"
                "https://www.google.hu/search*"
                "https://www.google.co.id/search*"
                "https://www.google.ie/search*"
                "https://www.google.co.il/search*"
                "https://www.google.im/search*"
                "https://www.google.co.in/search*"
                "https://www.google.iq/search*"
                "https://www.google.is/search*"
                "https://www.google.it/search*"
                "https://www.google.je/search*"
                "https://www.google.com.jm/search*"
                "https://www.google.jo/search*"
                "https://www.google.co.jp/search*"
                "https://www.google.co.ke/search*"
                "https://www.google.com.kh/search*"
                "https://www.google.ki/search*"
                "https://www.google.kg/search*"
                "https://www.google.co.kr/search*"
                "https://www.google.com.kw/search*"
                "https://www.google.kz/search*"
                "https://www.google.la/search*"
                "https://www.google.com.lb/search*"
                "https://www.google.li/search*"
                "https://www.google.lk/search*"
                "https://www.google.co.ls/search*"
                "https://www.google.lt/search*"
                "https://www.google.lu/search*"
                "https://www.google.lv/search*"
                "https://www.google.com.ly/search*"
                "https://www.google.co.ma/search*"
                "https://www.google.md/search*"
                "https://www.google.me/search*"
                "https://www.google.mg/search*"
                "https://www.google.mk/search*"
                "https://www.google.ml/search*"
                "https://www.google.com.mm/search*"
                "https://www.google.mn/search*"
                "https://www.google.ms/search*"
                "https://www.google.com.mt/search*"
                "https://www.google.mu/search*"
                "https://www.google.mv/search*"
                "https://www.google.mw/search*"
                "https://www.google.com.mx/search*"
                "https://www.google.com.my/search*"
                "https://www.google.co.mz/search*"
                "https://www.google.com.na/search*"
                "https://www.google.com.ng/search*"
                "https://www.google.com.ni/search*"
                "https://www.google.ne/search*"
                "https://www.google.nl/search*"
                "https://www.google.no/search*"
                "https://www.google.com.np/search*"
                "https://www.google.nr/search*"
                "https://www.google.nu/search*"
                "https://www.google.co.nz/search*"
                "https://www.google.com.om/search*"
                "https://www.google.com.pa/search*"
                "https://www.google.com.pe/search*"
                "https://www.google.com.pg/search*"
                "https://www.google.com.ph/search*"
                "https://www.google.com.pk/search*"
                "https://www.google.pl/search*"
                "https://www.google.pn/search*"
                "https://www.google.com.pr/search*"
                "https://www.google.ps/search*"
                "https://www.google.pt/search*"
                "https://www.google.com.py/search*"
                "https://www.google.com.qa/search*"
                "https://www.google.ro/search*"
                "https://www.google.ru/search*"
                "https://www.google.rw/search*"
                "https://www.google.com.sa/search*"
                "https://www.google.com.sb/search*"
                "https://www.google.sc/search*"
                "https://www.google.se/search*"
                "https://www.google.com.sg/search*"
                "https://www.google.sh/search*"
                "https://www.google.si/search*"
                "https://www.google.sk/search*"
                "https://www.google.com.sl/search*"
                "https://www.google.sn/search*"
                "https://www.google.so/search*"
                "https://www.google.sm/search*"
                "https://www.google.sr/search*"
                "https://www.google.st/search*"
                "https://www.google.com.sv/search*"
                "https://www.google.td/search*"
                "https://www.google.tg/search*"
                "https://www.google.co.th/search*"
                "https://www.google.com.tj/search*"
                "https://www.google.tl/search*"
                "https://www.google.tm/search*"
                "https://www.google.tn/search*"
                "https://www.google.to/search*"
                "https://www.google.com.tr/search*"
                "https://www.google.tt/search*"
                "https://www.google.com.tw/search*"
                "https://www.google.co.tz/search*"
                "https://www.google.com.ua/search*"
                "https://www.google.co.ug/search*"
                "https://www.google.co.uk/search*"
                "https://www.google.com.uy/search*"
                "https://www.google.co.uz/search*"
                "https://www.google.com.vc/search*"
                "https://www.google.co.ve/search*"
                "https://www.google.vg/search*"
                "https://www.google.co.vi/search*"
                "https://www.google.com.vn/search*"
                "https://www.google.vu/search*"
                "https://www.google.ws/search*"
                "https://www.google.rs/search*"
                "https://www.google.co.za/search*"
                "https://www.google.co.zm/search*"
                "https://www.google.co.zw/search*"
                "https://www.google.cat/search*"
              ];
            };
          };
        };
      };
    };
}

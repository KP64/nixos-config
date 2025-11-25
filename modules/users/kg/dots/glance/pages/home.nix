{ inputs, ... }:
{
  flake.modules.homeManager.users-kg-glance =
    { config, lib, ... }:
    let
      invisible = import (inputs.nix-invisible + /users/${config.home.username}.nix);
    in
    {
      # The mkBefore is to "set" the default page
      services.glance.settings.pages = lib.mkBefore [
        {
          name = "Home";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "clock";
                  hour-format = "24h";
                  timezones = [
                    {
                      timezone = "Asia/Amman";
                      label = "Amman";
                    }
                    {
                      timezone = "Asia/Tokyo";
                      label = "Tokyo";
                    }
                  ];
                }
                { type = "calendar"; }
                {
                  type = "rss";
                  collapse-after = 3;
                  single-line-titles = true;
                  feeds = [
                    {
                      title = "Selfhst";
                      url = "https://selfh.st/rss";
                    }
                    {
                      title = "NixOS Announcements";
                      url = "https://nixos.org/blog/announcements-rss.xml";
                    }
                    {
                      title = "Rust";
                      url = "https://blog.rust-lang.org/feed.xml";
                    }
                    {
                      title = "Mara";
                      url = "https://blog.m-ou.se/index.xml";
                    }
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "videos";
                  channels = [
                    "UCdp4_l1vPmpN-gDbUwhaRUQ" # Branch education
                    "UCsXVk37bltHxD1rDPwtNM8Q" # Kurzgesagt - In a Nutshell
                    "UCXuqSBlHAE6Xw-yeJA0Tunw" # Linus Tech Tips
                    "UC_zBdZ0_H_jn41FDRG7q4Tw" # Vimjoyer
                    "UCZgt6AzoyjslHTC9dz0UoTw" # ByteByteGo
                  ];
                }
                {
                  type = "group";
                  widgets =
                    map
                      (sub: {
                        type = "reddit";
                        subreddit = sub;
                      })
                      [
                        "news"
                        "gamingnews"
                        "technology"
                      ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  hour-format = "24h";
                  inherit (invisible) location;
                }
                {
                  type = "markets";
                  markets = [
                    {
                      symbol = "SPY";
                      name = "S&P 500";
                    }
                    {
                      symbol = "BTC-USD";
                      name = "Bitcoin";
                    }
                    {
                      symbol = "NVDA";
                      name = "Nvidia";
                    }
                    {
                      symbol = "AMD";
                      name = "Amd";
                    }
                    {
                      symbol = "GOOGL";
                      name = "Google";
                    }
                  ];
                }
                {
                  type = "releases";
                  show-source-icon = true;
                  repositories = [ "glanceapp/glance" ];
                }
              ];
            }
          ];
        }
      ];
    };
}

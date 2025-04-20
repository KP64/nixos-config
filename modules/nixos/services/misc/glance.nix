{ config, lib, ... }:
let
  cfg = config.services.misc.glance;
in
{
  options.services.misc.glance = {
    enable = lib.mkEnableOption "Glance";
    theme = lib.mkOption {
      type = lib.types.attrs;
      description = "The colors everything should take.";
      default = {
        background-color = "240 21 15";
        contrast-multiplier = 1.2;
        primary-color = "217 92 83";
        positive-color = "115 54 76";
        negative-color = "347 70 65";
      };
    };
    location = lib.mkOption {
      readOnly = true;
      type = lib.types.nonEmptyStr;
      description = "The weather of the City.";
      example = "Berlin, Germany";
    };
  };

  # TODO: Use communnity Widgets
  #  - Mealie
  #  - Media (Jellyfin)
  #  - Steam specials
  #  - Minecraft Server
  config = lib.mkIf cfg.enable {
    services = {
      traefik.dynamicConfigOptions.http = {
        routers.glance = {
          rule = "Host(`glance.${config.networking.domain}`)";
          service = "glance";
        };
        services.glance.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.glance.settings.server.port}"; }
        ];
      };

      glance = {
        enable = true;
        settings = {
          server.port = 5678;
          inherit (cfg) theme;
          pages = [
            {
              name = "Home";
              columns = [
                {
                  size = "small";
                  widgets = [
                    { type = "calendar"; }
                    {
                      type = "rss";
                      limit = 10;
                      collapse-after = 3;
                      cache = "3h";
                      feeds = [
                        { url = "https://ciechanow.ski/atom.xml"; }
                        {
                          url = "https://www.joshwcomeau.com/rss.xml";
                          title = "Josh Comeau";
                        }
                        { url = "https://samwho.dev/rss.xml"; }
                        { url = "https://awesomekling.github.io/feed.xml"; }
                        {
                          url = "https://ishadeed.com/feed.xml";
                          title = "Ahmad Shadeed";
                        }
                      ];
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    {
                      type = "search";
                      search-engine = "https://searxng.nix-pi.ipv64.de/search?q={QUERY}&language=all";
                      autofocus = true;
                      # TODO: Add more bangs
                      bangs = [
                        {
                          title = "YouTube";
                          shortcut = "!yt";
                          url = "https://www.youtube.com/results?search_query={QUERY}";
                        }
                      ];
                    }
                    {
                      type = "videos";
                      channels = [
                        "UCXuqSBlHAE6Xw-yeJA0Tunw" # LTT
                        "UCeeFfhMcJa1kjtfZAGskOCA" # TechLinked
                        "UC6biysICWOJ-C3P4Tyeggzg" # Low Level
                        "UCSp-OaMpsO8K0KkOqyBl7_w" # Let's Get Rusty
                        "UC_zBdZ0_H_jn41FDRG7q4Tw" # Vimjoyer
                        "UC9x0AN7BWHpCDHSm9NiJFJQ" # NetworkChuck
                      ];
                    }
                    {
                      type = "hacker-news";
                      limit = 15;
                      collapes-after = 5;
                    }
                  ];
                }
                {
                  size = "small";
                  widgets = [
                    {
                      type = "weather";
                      hour-format = "24h";
                      hide-location = true;
                      inherit (cfg) location;
                    }
                    {
                      type = "markets";
                      markets = [
                        {
                          symbol = "BTC-USD";
                          name = "Bitcoin";
                        }
                        {
                          symbol = "NVDA";
                          name = "NVIDIA";
                        }
                        {
                          symbol = "AAPL";
                          name = "Apple";
                        }
                        {
                          symbol = "MSFT";
                          name = "Microsoft";
                        }
                        {
                          symbol = "GOOGL";
                          name = "Google";
                        }
                        {
                          symbol = "AMD";
                          name = "AMD";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
            {
              name = "Markets";
              columns = [
                {
                  size = "small";
                  widgets = [
                    {
                      type = "markets";
                      title = "Indices";
                      markets = [
                        {
                          symbol = "SPY";
                          name = "S&P 500";
                        }
                        {
                          symbol = "DX-Y.NYB";
                          name = "Dollar Index";
                        }
                      ];
                    }
                    {
                      type = "markets";
                      title = "Crypto";
                      markets = [
                        {
                          symbol = "BTC-USD";
                          name = "Bitcoin";
                        }
                        {
                          symbol = "ETH-USD";
                          name = "Ethereum";
                        }
                        {
                          symbol = "XMR-USD";
                          name = "Monero";
                        }
                      ];
                    }
                    {
                      type = "markets";
                      title = "Stocks";
                      sort-by = "absolute-change";
                      markets = [
                        {
                          symbol = "NVDA";
                          name = "NVIDIA";
                        }
                        {
                          symbol = "AAPL";
                          name = "Apple";
                        }
                        {
                          symbol = "MSFT";
                          name = "Microsoft";
                        }
                        {
                          symbol = "GOOGL";
                          name = "Google";
                        }
                        {
                          symbol = "AMD";
                          name = "AMD";
                        }
                        {
                          symbol = "RDDT";
                          name = "Reddit";
                        }
                        {
                          symbol = "AMZN";
                          name = "Amazon";
                        }
                        {
                          symbol = "TSLA";
                          name = "Tesla";
                        }
                        {
                          symbol = "INTC";
                          name = "Intel";
                        }
                        {
                          symbol = "META";
                          name = "Meta";
                        }
                      ];
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    {
                      type = "rss";
                      title = "News";
                      style = "horizontal-cards";
                      feeds = [
                        {
                          url = "https://feeds.bloomberg.com/markets/news.rss";
                          title = "Bloomberg";
                        }
                        {
                          url = "https://moxie.foxbusiness.com/google-publisher/markets.xml";
                          title = "Fox Business";
                        }
                        {
                          url = "https://moxie.foxbusiness.com/google-publisher/technology.xml";
                          title = "Fox Business";
                        }
                      ];
                    }
                    {
                      type = "group";
                      widgets = [
                        {
                          type = "reddit";
                          show-thumbnails = true;
                          subreddit = "technology";
                        }
                        {
                          type = "reddit";
                          show-thumbnails = true;
                          subreddit = "wallstreetbets";
                        }
                      ];
                    }
                    {
                      type = "videos";
                      style = "grid-cards";
                      collapse-after-rows = 3;
                      channels = [
                        "UCvSXMi2LebwJEM1s4bz5IBA" # New Money
                        "UCV6KDgJskWaEckne5aPA0aQ" # Graham Stephan
                        "UCAzhpt9DmG6PnHXjmJTvRGQ" # Federal Reserve
                      ];
                    }
                  ];
                }
                {
                  size = "small";
                  widgets = [
                    {
                      type = "rss";
                      title = "News";
                      limit = 30;
                      collapse-after = 13;
                      feeds = [
                        {
                          url = "https://www.ft.com/technology?format=rss";
                          title = "Financial Times";
                        }
                        {
                          url = "https://feeds.a.dj.com/rss/RSSMarketsMain.xml";
                          title = "Wall Street Journal";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
            {
              name = "Gaming";
              columns = [
                {
                  size = "small";
                  widgets = [
                    {
                      type = "twitch-top-games";
                      limit = 20;
                      collapse-after = 13;
                      exclude = [
                        "just-chatting"
                        "pools-hot-tubs-and-beaches"
                        "music"
                        "art"
                        "asmr"
                      ];
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    {
                      type = "group";
                      widgets = [
                        {
                          type = "reddit";
                          show-thumbnails = true;
                          subreddit = "pcgaming";
                        }
                        {
                          type = "reddit";
                          subreddit = "games";
                        }
                      ];
                    }
                    {
                      type = "videos";
                      style = "grid-cards";
                      collapse-after-rows = 3;
                      channels = [
                        "UCNvzD7Z-g64bPXxGzaQaa4g" # gameranx
                        "UCZ7AeeVbyslLM_8-nVy2B8Q" # Skill Up
                        "UCHDxYLv8iovIbhrfl16CNyg" # GameLinked
                        "UC9PBzalIcEQCsiIkq36PyUA" # Digital Foundry
                      ];
                    }
                  ];
                }
                {
                  size = "small";
                  widgets = [
                    {
                      type = "reddit";
                      subreddit = "gamingnews";
                      limit = 7;
                      style = "vertical-cards";
                    }
                  ];
                }
              ];
            }
          ];
        };
      };
    };
  };
}

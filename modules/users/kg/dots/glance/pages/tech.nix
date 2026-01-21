toplevel: {
  flake.modules.homeManager.users-kg-glance = {
    services.glance.settings.pages = [
      {
        name = "Tech";
        columns = [
          {
            size = "small";
            widgets = [
              {
                type = "rss";
                single-line-titles = true;
                feeds = [
                  {
                    title = "Nick Cunningham";
                    url = "https://nickcunningh.am/blog/feed";
                  }
                  {
                    title = "Pid Eins";
                    url = "https://0pointer.net/blog/index.rss20";
                  }
                  {
                    title = "Benjojo";
                    url = "https://blog.benjojo.co.uk/rss.xml";
                  }
                  {
                    title = "SimpleX Chat";
                    url = "https://simplex.chat/feed.rss";
                  }
                  {
                    title = "NixOS Announcement";
                    url = "https://nixos.org/blog/announcements-rss.xml";
                  }
                  {
                    title = "selfh.st";
                    url = "https://selfh.st/rss";
                  }
                  {
                    title = "Haseeb Majid";
                    url = "https://haseebmajid.dev/posts/index.xml";
                  }
                  {
                    title = "Akash Rajpurohit";
                    url = "https://akashrajpurohit.com/rss.xml";
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
                  "UCXuqSBlHAE6Xw-yeJA0Tunw" # LTT
                  "UCdp4_l1vPmpN-gDbUwhaRUQ" # Branch Education
                  "UCZgt6AzoyjslHTC9dz0UoTw" # ByteByteGo
                  "UCYeiozh-4QwuC1sjgCmB92w" # DevOps Toolbox
                  "UCsBjURrPoezykLs9EqgamOA" # Fireship
                  "UC7YOGHUfC1Tb6E4pudI9STA" # Mental Outlaw
                  "UC_zBdZ0_H_jn41FDRG7q4Tw" # Vimjoyer
                  "UCeeFfhMcJa1kjtfZAGskOCA" # Tech linked
                  "UCgdTVe88YVSrOZ9qKumhULQ" # Hardware Haven
                  "UCR-DXc1voovS8nhAvccRZhg" # Jeff Geerling
                  "UCZNhwA1B5YqiY1nLzmM0ZRg" # Christian Lempa
                  "UCsnGwSIHyoYN0kiINAGUKxg" # Wolfgang's Channel
                  "UCOk-gHyjcWZNj3Br4oxwh0A" # Techno Tim
                ];
              }
              {
                type = "group";
                widgets = [
                  {
                    type = "hacker-news";
                    collapse-after = 3;
                  }
                ]
                ++
                  map
                    (subreddit: {
                      type = "reddit";
                      inherit subreddit;
                      collapse-after = 3;
                    })
                    [
                      "rust"
                      "nixos"
                      "selfhosted"
                      "homelab"
                      "privacy"
                    ];
              }
            ];
          }
          {
            size = "small";
            widgets = [
              { type = "server-stats"; }
              {
                type = "monitor";
                cache = "1m";
                title = "Services";
                sites =
                  let
                    inherit (toplevel.config.flake.nixosConfigurations) mahdi;
                  in
                  [
                    {
                      title = "Forgejo";
                      url = mahdi.config.services.forgejo.settings.server.ROOT_URL;
                      icon = "sh:forgejo";
                    }
                    {
                      title = "Redlib";
                      url = mahdi.config.services.redlib.settings.REDLIB_FULL_URL;
                      icon = "sh:redlib";
                    }
                    {
                      title = "SearXNG";
                      url = mahdi.config.services.searx.settings.server.base_url;
                      icon = "sh:searxng";
                    }
                    {
                      title = "Open WebUI";
                      url = mahdi.config.services.open-webui.environment.WEBUI_URL;
                      icon = "sh:open-webui";
                    }
                  ];
              }
            ];
          }
        ];
      }
    ];
  };
}

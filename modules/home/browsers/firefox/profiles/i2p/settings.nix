{ lib }:
lib.custom.collectLastEntries
<| lib.custom.appendLastWithFullPath
<| {
  keyword.enabled = false;
  browser = {
    contentblocking.category = "strict";
    policies.applied = true;
  };
  network = {
    trr.mode = 5;
    proxy = {
      http = "127.0.0.1";
      http_port = 4444;
      share_proxy_settings = true;
      socks = "127.0.0.1";
      socks_port = 4447;
      type = 1;
    };
  };
}

{
  flake.modules.nixvim.leetcode = {
    plugins.leetcode = {
      enable = true;
      settings.lang = "rust";
      lazyLoad.settings.cmd = "Leet";
    };
  };
}

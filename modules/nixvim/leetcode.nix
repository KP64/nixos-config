{
  flake.aspects.leetcode.nixvim = {
    plugins.leetcode = {
      enable = true;
      settings.lang = "rust";
      lazyLoad.settings.cmd = "Leet";
    };
  };
}

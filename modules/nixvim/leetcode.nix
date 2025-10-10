{
  flake.modules.nixvim.leetcode = {
    plugins.leetcode = {
      enable = true;
      settings.lang = "rust";
    };
  };
}

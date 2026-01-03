{
  flake.modules.homeManager.users-kg-neovim =
    { pkgs, ... }:
    {
      programs.nixvim = {
        extraPackagesAfter = [ pkgs.graphviz ];
        plugins = {
          rustaceanvim.enable = true;
          crates = {
            enable = true;
            lazyLoad.settings.event = "BufRead Cargo.toml";
          };
        };
      };
    };
}

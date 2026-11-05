{ lib, pkgs, ... }: {
  extraPackagesAfter = [ pkgs.graphviz ];
  lsp.servers.rust_analyzer.enable = lib.mkForce false;
  plugins = {
    rustaceanvim.enable = true;
    crates = {
      enable = true;
      lazyLoad.settings.event = "BufRead Cargo.toml";
    };
  };
}

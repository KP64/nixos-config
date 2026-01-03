{ config, ... }:
{
  flake.modules.nixvim.lsp = {
    imports = with config.flake.modules.nixvim; [
      blink
      conform
      dap
      lint
    ];

    performance.combinePlugins.standalonePlugins = [ "friendly-snippets" ];

    plugins = {
      lspconfig.enable = true;
      friendly-snippets.enable = true;
    };

    lsp =
      let
        enableAsFallback = {
          enable = true;
          packageFallback = true;
        };
      in
      {
        inlayHints.enable = true;
        servers = {
          bashls = enableAsFallback;
          clangd = enableAsFallback;
          jdtls = enableAsFallback;
          just = enableAsFallback;
          lua_ls = enableAsFallback;
          nil_ls = enableAsFallback // {
            config.nix.flake.autoEvalInputs = true;
          };
          nushell = enableAsFallback;
          ruff = enableAsFallback;
          rust_analyzer = enableAsFallback;
          statix = enableAsFallback;
          taplo = enableAsFallback;
          typos_lsp = enableAsFallback;
          tinymist = enableAsFallback // {
            config.formatterMode = "typststyle";
          };
        };
      };
  };
}

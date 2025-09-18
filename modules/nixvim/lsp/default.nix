{
  flake.modules.nixvim.lsp =
    { pkgs, ... }:
    {
      # Faster replacement for libuv-watchdirs
      extraPackages = [ pkgs.inotify-tools ];

      plugins.lspconfig.enable = true;

      lsp = {
        inlayHints.enable = true;
        servers = {
          "*".settings = {
            capabilities.textDocument.semanticTokens.multilineTokenSupport = true;
            root_markers = [ ".git" ];
          };
          bashls.enable = true;
          clangd = {
            enable = true;
            settings = {
              cmd = [
                "clangd"
                "--background-index"
              ];
              filetypes = [
                "c"
                "cpp"
                "h"
                "hpp"
                "ipp"
              ];
              root_markers = [
                "compile_commands.json"
                "compile_flags.txt"
              ];
            };
          };
          emmet_language_server = {
            enable = true;
            settings = {
              cmd = [
                "emmet-language-server"
                "--stdio"
              ];
              filetypes = [
                "css"
                "eruby"
                "html"
                "javascript"
                "javascriptreact"
                "less"
                "sass"
                "scss"
                "pug"
                "typescriptreact"
              ];
            };
          };
          harper_ls = {
            enable = true;
            settings.settings."harper-ls".linters = {
              SpelledNumbers = true;
              UseGenitive = true;
              PossessiveNoun = true;
              BoringWords = true;

              # Counterproductive for programming
              SpellCheck = false;
              SentenceCapitalization = false;
            };
          };
          just.enable = true;
          lua_ls.enable = true;
          nixd.enable = true;
          nushell.enable = true;
          ruff.enable = true;
          rust-analyzer = {
            enable = true;
            settings = {
              cmd = [ "rust-analyzer" ];
              filetypes = [ "rust" ];
              assist = {
                emitMustUse = true;
                preferSelf = true;
              };
              completion.fullFunctionSignatures.enable = true;
              diagnostics.styleLints.enable = true;
              inlayHints = {
                bindingModeHints.enable = true;
                closureCaptureHints.enable = true;
                discriminantHints.enable = true;
                genericParameterHints = {
                  lifetime.enable = true;
                  type.enable = true;
                };
                implicitSizedBoundHints.enable = true;
                rangeExclusiveHints.enable = true;
              };
              lens.references = {
                adt.enable = true;
                enumVariant.enable = true;
                method.enable = true;
                trait.enable = true;
              };
            };
          };
          statix.enable = true;
          taplo.enable = true;
          typos_lsp.enable = true;
        };
      };
    };
}

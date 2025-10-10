{ config, ... }:
{
  flake.modules.nixvim.lsp =
    { pkgs, ... }:
    {
      imports = with config.flake.modules.nixvim; [
        blink
        conform
        dap
        lint
      ];

      # Faster replacement for libuv-watchdirs
      extraPackages = [ pkgs.inotify-tools ];

      plugins.lspconfig.enable = true;

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
            just = enableAsFallback;
            lua_ls = enableAsFallback;
            nil_ls = enableAsFallback // {
              config.nix.flake.autoEvalInputs = true;
            };
            nushell = enableAsFallback;
            ruff = enableAsFallback;
            rust_analyzer = enableAsFallback // {
              config = {
                assist.preferSelf = true;
                completion = {
                  fullFunctionSignatures.enable = true;
                  termSearch.enable = true;
                };
                diagnostics.styleLints.enable = true;
                hover.actions.references = true;
                inlayHints = {
                  bindingModeHints.enable = true;
                  closureCaptureHints.enable = true;
                  closureReturnTypeHints.enable = "with_block";
                  discriminantHints.enable = "fieldless";
                  expressionAdjustmentHints = {
                    enable = "always";
                    hideOutsideUnsafe = true;
                    mode = "prefer_prefix";
                  };
                  genericParameterHints = {
                    lifetime.enable = true;
                    type.enable = true;
                  };
                  implicitSizedBoundHints.enable = true;
                  lifetimeElisionHints = {
                    enable = "skip_trivial";
                    useParameterNames = true;
                  };
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

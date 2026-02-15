{
  flake.aspects.noice.nixvim = {
    plugins = {
      notify.enable = true;
      noice = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        settings = {
          presets.lsp_doc_border = true;
          lsp.override =
            let
              lspUtil = "vim.lsp.util";
            in
            {
              "${lspUtil}.convert_input_to_markdown_lines" = true;
              "${lspUtil}.stylize_markdown" = true;
            };
        };
      };
    };
  };
}

{
  # TODO: LazyLoad, such that nui & notify load before noice
  plugins = {
    notify.enable = true;
    nui.enable = true;
    noice = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
      settings = {
        presets.lsp_doc_border = true;
        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
        };
      };
    };
  };
}

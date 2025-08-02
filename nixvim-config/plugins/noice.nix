{
  plugins = {
    notify.enable = true;
    nui.enable = true;
    noice = {
      enable = true;
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

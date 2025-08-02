{
  plugins = rec {
    # TODO: Test once LSP is online
    # TODO: Shortcuts
    inc-rename.enable = true;
    notify.enable = true;
    nui.enable = true;
    noice = {
      enable = true;
      settings = {
        presets = {
          inc_rename = inc-rename.enable;
          lsp_doc_border = true; # TODO: Check if works, when LSP online
        };
        # TODO: Does this work as intended?
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
}

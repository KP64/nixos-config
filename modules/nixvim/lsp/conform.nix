{
  flake.modules.nixvim.conform = {
    plugins.conform-nvim = {
      enable = true;
      lazyLoad.settings = {
        cmd = [ "ConformInfo" ];
        event = [
          "BufWritePre"
          "BufReadPre"
          "BufNewFile"
        ];
      };
      autoInstall.enable = true;
      settings = {
        default_format_opts.lsp_format = "fallback";
        format_on_save.timeoutMs = 500;
        formatters_by_ft = rec {
          html = [ "prettier" ];
          css = html;
          javascript = html;
          typescript = html;
          markdown = html;

          bash = [
            "shellcheck"
            "shfmt"
          ];
          sh = bash;

          lua = [ "stylua" ];
          python = [ "ruff" ];
          rust = [ "rustfmt" ];
          just = [ "just" ];
          nix = [ "nixfmt" ];
          toml = [ "taplo" ];
          typst = [ "typstyle" ];
        };
      };
    };

    keymaps =
      map
        (
          { mode, desc }:
          {
            inherit mode;
            key = "<leader>cf";
            action = "<cmd>lua require('conform').format { async = true }<cr>";
            options = {
              silent = true;
              inherit desc;
            };
          }
        )
        [
          {
            mode = "n";
            desc = "Format Buffer";
          }
          {
            mode = "v";
            desc = "Format Lines";
          }
        ];
  };
}

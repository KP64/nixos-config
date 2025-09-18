{
  flake.modules.nixvim.conform =
    { lib, pkgs, ... }:
    {
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
        settings = {
          default_format_opts.lsp_format = "fallback";
          format_on_save.timeoutMs = 500;
          formatters = builtins.mapAttrs (_: v: { command = lib.getExe v; }) {
            inherit (pkgs)
              prettierd
              shellcheck
              shfmt
              stylua
              ruff
              rustfmt
              just
              nixfmt
              taplo
              ;
          };
          formatters_by_ft = rec {
            html = [ "prettierd" ];
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

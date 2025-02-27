{ pkgs, ... }:
# TODO: customize further
{
  config.vim = {
    enableLuaLoader = true;
    lineNumberMode = "relNumber";

    autocomplete.blink-cmp = {
      enable = true;
      setupOpts.signature.enabled = true;
    };

    autopairs.nvim-autopairs.enable = true;

    binds.whichKey.enable = true;

    comments.comment-nvim = {
      enable = true;
      setupOpts.mappings = {
        basic = true;
        extra = true;
      };
    };

    dashboard.dashboard-nvim.enable = true;

    debugger.nvim-dap = {
      enable = true;
      ui.enable = true;
    };

    filetree.neo-tree = {
      enable = true;
      setupOpts = {
        auto_clean_after_session_restore = true;
        git_status_async = true;
      };
    };

    formatter.conform-nvim.enable = true;

    git = {
      enable = true;
      gitsigns.codeActions.enable = true;
    };

    languages = {
      enableDAP = true;
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableLSP = true;
      enableTreesitter = true;

      assembly.enable = true;
      bash.enable = true;
      clang.enable = true;
      css.enable = true;
      go.enable = true;
      # Not the same as terraform:
      # https://github.com/NotAShelf/nvf/pull/359
      hcl.enable = true;
      html.enable = true;
      java.enable = true;
      markdown = {
        enable = true;
        extensions.render-markdown-nvim.enable = true;
      };
      nix = {
        enable = true;
        lsp = {
          package = pkgs.nixd;
          server = "nixd";
        };
      };
      nu.enable = true;
      python.enable = true;
      rust = {
        enable = true;
        crates.enable = true;
      };
      sql.enable = true;
      svelte.enable = true;
      tailwind.enable = true;
      terraform.enable = true;
      ts = {
        enable = true;
        extensions.ts-error-translator.enable = true;
      };
      typst.enable = true;
    };

    lsp = {
      enable = true;
      formatOnSave = true;
      lspconfig.enable = true;
      lspkind.enable = true;
      lspsaga.enable = true;
      nvim-docs-view.enable = true;
      otter-nvim = {
        enable = true;
        setupOpts.buffers = {
          write_to_disk = true;
          handle_leading_whitespace = true;
        };
      };
      trouble.enable = true;
    };

    notes.todo-comments.enable = true;

    notify.nvim-notify.enable = true;

    projects.project-nvim = {
      enable = true;
      setupOpts.show_hidden = true;
    };

    snippets.luasnip = {
      enable = true;
      setupOpts.enable_autosnippets = true;
    };

    statusline.lualine.enable = true;

    tabline.nvimBufferline.enable = true;

    telescope.enable = true;

    terminal.toggleterm = {
      enable = true;
      lazygit.enable = true;
      setupOpts.enable_winbar = true;
    };

    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
    };

    treesitter = {
      enable = true;
      autotagHtml = true;
      fold = true;
      context.enable = true;
    };

    ui = {
      borders.enable = true;
      breadcrumbs = {
        enable = true;
        navbuddy.enable = true;
      };
      colorizer.enable = true;
      fastaction.enable = true;
      illuminate.enable = true;
      noice = {
        enable = true;
        setupOpts = {
          lsp.signature.enabled = true;
          presets = {
            inc_rename = true;
            lsp_doc_border = true;
          };
        };
      };
    };

    undoFile.enable = true;

    utility = {
      diffview-nvim.enable = true;
      leetcode-nvim.enable = true;
      motion = {
        leap.enable = true;
        precognition.enable = true;
      };
      multicursors.enable = true;
      outline.aerial-nvim.enable = true;
      preview.glow.enable = true;
      surround.enable = true;
      yanky-nvim.enable = true;
      yazi-nvim.enable = true;
    };

    visuals = {
      cinnamon-nvim.enable = true;
      nvim-web-devicons.enable = true;
      rainbow-delimiters.enable = true;
    };
  };
}

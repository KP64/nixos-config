{ pkgs, ... }:
{
  config.vim = {
    enableLuaLoader = true;
    lineNumberMode = "relNumber";

    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers.wl-copy = {
        enable = true;
        package = pkgs.wl-clipboard-rs;
      };
    };

    options = {
      tabstop = 4;
      shiftwidth = 4;
    };

    withNodeJs = true;
    withRuby = false;

    extraPackages = with pkgs; [
      # System
      curl
      git

      # fzf-lua
      ## required
      fzf
      git
      ripgrep
      fd
      ## optional:media
      viu
      chafa
      ueberzugpp

      # nvim-treesitter
      tree-sitter
      gcc
    ];

    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
    };

    autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
      sourcePlugins = {
        emoji.enable = true;
        ripgrep.enable = true;
        spell.enable = true;
      };
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

    dashboard.dashboard-nvim = {
      enable = true;
      setupOpts.config = {
        week_header.enable = true;
        packages.enable = false;
        footer = [ "There is always one more 🐛 to fix" ];
      };
    };

    # debugger.nvim-dap = {
    #   enable = true;
    #   ui.enable = true;
    # };

    diagnostics.nvim-lint.enable = true;

    # TODO: Try out which one is better
    # filetree.nvimTree
    # filetree.neo-tree = {
    #   enable = true;
    #   setupOpts = {
    #     enable_cursor_hijack = true;
    #     git_status_async = true;
    #   };
    # };

    formatter.conform-nvim.enable = true;

    git.enable = true;

    languages = {
      enableDAP = true;
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableTreesitter = true;

      assembly.enable = true;
      bash.enable = true;
      clang.enable = true;
      css.enable = true;
      hcl.enable = true;
      helm.enable = true;
      html.enable = true;
      markdown = {
        enable = true;
        extensions.render-markdown-nvim = {
          enable = true;
          # TODO: Enable again when supported
          setupOpts.latex.enabled = false;
        };
      };
      nix = {
        enable = true;
        format.type = "nixfmt";
        lsp.server = "nixd";
      };
      nu.enable = true;
      python = {
        enable = true;
        format.type = "ruff";
      };
      rust = {
        enable = true;
        crates.enable = true;
        dap.enable = false; # FIX: lldb-dap hangs
      };
      sql.enable = true;
      svelte.enable = true;
      tailwind.enable = true;
      terraform.enable = true;
      ts = {
        enable = true;
        extensions.ts-error-translator.enable = true;
      };
      typst = {
        enable = true;
        extensions.typst-preview-nvim.enable = true;
        format.type = "typstyle";
      };
      yaml.enable = true;
    };

    lsp = {
      enable = true;
      formatOnSave = true;
      # lspsaga.enable = true;
      inlayHints.enable = true;
      nvim-docs-view.enable = true;
      otter-nvim = {
        enable = true;
        setupOpts = {
          buffers.write_to_disk = true;
          handle_leading_whitespace = true;
        };
      };
      trouble.enable = true;
    };

    mini.icons.enable = true;

    notes = {
      # neorg.enable = true;
      # obsidian.enable = true;
      todo-comments.enable = true;
    };

    notify.nvim-notify.enable = true;

    # projects.project-nvim.enable = true;

    # runner.run-nvim.enable = true;

    # session.nvim-session-manager.enable = true;

    # snippets.luasnip = {
    #   enable = true;
    #   enable_autosnippets = true;
    # };

    statusline.lualine = {
      enable = true;
      refresh =
        let
          time_ms = 100;
        in
        {
          statusline = time_ms;
          tabline = time_ms;
          winbar = time_ms;
        };
    };

    tabline.nvimBufferline.enable = true;

    telescope.enable = true;

    # terminal.toggleterm = {
    #   enable = true;
    #   lazygit.enable = true;
    #   TODO: Check why both exist?
    #   setupOpts.enable_winbar = true;
    #   setupOpts.winbar.enabled = true;
    # };

    treesitter = {
      autotagHtml = true;
      context.enable = true;
    };

    ui = {
      borders.enable = true;

      colorizer.enable = true;

      # fastaction.enable = true;

      illuminate.enable = true;

      noice = {
        enable = true;
        setupOpts = {
          lsp.signature.enabled = true;
          presets.bottom_search = false;
        };
      };
    };

    utility = {
      # diffview-nvim.enable = true;

      images.image-nvim = {
        enable = true;
        setupOpts = {
          backend = "ueberzug";
          integrations = {
            markdown.downloadRemoteImages = true;
            neorg.downloadRemoteImages = true;
          };
        };
      };

      leetcode-nvim = {
        enable = true;
        setupOpts = {
          arg = "lc";
          image_support = true;
        };
      };

      mkdir.enable = true;

      # motion.flash-nvim.enable = true;

      # multicursors.enable = true;

      oil-nvim.enable = true;

      # outline.aerial-nvim.enable = true;

      # surround.enable = true;

      # yanky-nvim.enable = true;

      yazi-nvim.enable = true;
    };

    visuals = {
      nvim-web-devicons.enable = true;

      rainbow-delimiters.enable = true;
    };
  };
}

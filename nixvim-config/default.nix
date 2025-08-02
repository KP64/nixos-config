{
  lib,
  pkgs,
  inputs,
  ...
}:
rec {
  imports = [
    ./lsp
    ./plugins
  ];

  package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

  withNodeJs = true;

  viAlias = true;
  vimAlias = true;

  luaLoader.enable = true;
  performance = {
    byteCompileLua = {
      enable = true;
      configs = true;
      luaLib = true;
      nvimRuntime = true;
      plugins = true;
    };
    combinePlugins.enable = true;
  };

  colorschemes.catppuccin.enable = true;

  globals = {
    mapleader = " ";
    have_nerd_font = true;
  };

  # plugins.avante.enable = true; # TODO: Configure

  # plugins.neorg.enable = true; # TODO: Configure

  # plugins.nvim-ufo.enable = true; # TODO: Configure? + This vs. Treesitter-folding

  # plugins.otter.enable = true; # TODO: Configure

  # TODO: Move to plugins folder
  plugins = {
    which-key.enable = true;
    web-devicons.enable = globals.have_nerd_font;
    mini-icons.enable = true;
  };

  plugins = {
    # TODO: Configure
    zen-mode.enable = true;
    twilight.enable = true;
  };

  clipboard = {
    providers = {
      wl-copy.enable = true;
      xsel.enable = true;
    };
    register = "unnamedplus";
  };

  opts = {
    number = true;
    relativenumber = true;

    breakindent = true;

    # Save undo history
    undofile = true;

    # Case-insensitive searching UNLESS \C or one or more capital letters in the search term
    ignorecase = true;
    smartcase = true;

    smartindent = true;

    # Keep it on by default
    signcolumn = "yes";

    # Configure how new splits should be opened
    splitright = true;
    splitbelow = true;

    # Set how neovim will display certain whitespace
    # characters in the editor
    # See :help 'list'
    # and :help 'listchars'
    list = true;
    listchars = lib.nixvim.mkRaw "{ tab = '» ', trail = '·', nbsp = '␣' }";

    # Preview substitutions live, as you type!
    # TODO: Confirm
    inccommand = "split";

    confirm = true;

    # FIX: Issues with telescope
    # winborder = "rounded";
  };

  # TODO: Enable after understanding what they are doing
  keymaps = [
    # {
    #   mode = "n";
    #   key = "<Esc>";
    #   action = "<cmd>nohlsearch<CR>";
    # }

    ###
    # Keybinds to make split navigation easier.
    #  Use CTRL+<hjkl> to switch between windows
    #
    #  See `:help wincmd` for a list of all window commands
    # {
    #   mode = "n";
    #   key = "<C-h>";
    #   action = "<C-w><C-h>";
    #   options.desc = "Move focus to the left window";
    # }
    # {
    #   mode = "n";
    #   key = "<C-l>";
    #   action = "<C-w><C-l>";
    #   options.desc = "Move focus to the right window";
    # }
    # {
    #   mode = "n";
    #   key = "<C-j>";
    #   action = "<C-w><C-j>";
    #   options.desc = "Move focus to the lower window";
    # }
    # {
    #   mode = "n";
    #   key = "<C-k>";
    #   action = "<C-w><C-k>";
    #   options.desc = "Move focus to the upper window";
    # }
  ];
}

{ inputs, ... }:
{
  flake.modules.nixvim.base =
    { lib, pkgs, ... }:
    {
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

      globals.mapleader = " ";

      plugins = {
        lz-n.enable = true;
        mini-icons.enable = true;
        web-devicons.enable = true;
        guess-indent.enable = true;
        nvim-autopairs = {
          enable = true;
          lazyLoad.settings.event = "InsertEnter";
        };
      };

      clipboard.register = "unnamedplus";

      opts = {
        number = true;
        relativenumber = true;

        breakindent = true;

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

        wrap = false;
        cursorline = true;

        inccommand = "split";

        # Set how neovim will display certain whitespace
        # characters in the editor
        # See :help 'list'
        # and :help 'listchars'
        list = true;
        listchars = lib.nixvim.mkRaw "{ tab = '» ', trail = '·', nbsp = '␣' }";

        confirm = true;
      };

      keymaps = [
        {
          mode = "n";
          key = "<Esc>";
          action = "<cmd>nohlsearch<CR>";
          options.desc = "Remove Search Highlighting";
        }

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
    };
}

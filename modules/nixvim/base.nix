{
  flake.modules.nixvim.base =
    { lib, ... }:
    {
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

      # Needed for vim.health
      dependencies =
        let
          defaultEnable = {
            enable = true;
            packageFallback = true;
          };
        in
        {
          curl = defaultEnable;
          git = defaultEnable;
          ripgrep = defaultEnable;
        };

      plugins = {
        lz-n.enable = true;
        mini-icons.enable = true;
        web-devicons.enable = true;
        guess-indent.enable = true;
        blink-pairs = {
          enable = true;
          settings.highlights.enabled = false;
        };
      };

      clipboard.register = "unnamedplus";

      opts = {
        number = true;
        relativenumber = true;

        cindent = true;

        undofile = true;

        # Case-insensitive searching UNLESS \C or one or more capital letters in the search term
        ignorecase = true;
        smartcase = true;

        # Configure how new splits should be opened
        splitright = true;
        splitbelow = true;

        wrap = false;

        inccommand = "split";

        # Set how neovim will display certain whitespace
        # characters in the editor
        # See :help 'list'
        # and :help 'listchars'
        list = true;
        listchars = lib.nixvim.mkRaw "{ tab = '» ', trail = '·', nbsp = '␣' }";
      };

      keymaps = [
        {
          mode = "n";
          key = "<Esc>";
          action = "<cmd>nohlsearch<CR>";
          options.desc = "Remove Search Highlighting";
        }
      ]
      # This simplifies window movement by one keypress :P
      ++ (lib.mapAttrsToList
        (direction: key: {
          mode = "n";
          key = "<C-${key}>";
          action = "<C-w><C-${key}>";
          options.desc = "Move focus to the ${direction} window";
        })
        {
          left = "h";
          right = "l";
          lower = "j";
          upper = "k";
        }
      );
    };
}

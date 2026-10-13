{ inputs, ... }: {
  den.aspects.kg.homeManager = { config, ... }: {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;

      colorschemes.catppuccin = {
        enable = true;
        lazyLoad.enable = true;
      };

      keymaps = [
        {
          action = config.lib.nixvim.mkRaw ''
            function()
              vim.cmd("enew")
              vim.bo.buftype = "nofile"
              vim.bo.bufhidden = "hide"
              vim.bo.swapfile = false
            end
          '';
          key = "<leader>sp";
          options.desc = "Scratchpad";
        }
      ];
    };
  };
}

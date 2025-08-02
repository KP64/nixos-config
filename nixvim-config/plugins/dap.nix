{ lib, ... }:
{
  plugins = {
    # TODO: Everything (shortcuts, configs, ...)
    dap.enable = true;
    # dap-lldb.enable = true; # TODO: Needed?
    # dap-python.enable = true; # TODO: Needed?
    dap-ui.enable = true;
  };

  keymaps = [
    # Basic debugging keymaps, feel free to change to your liking!
    {
      mode = "n";
      key = "<F5>";
      action =
        lib.nixvim.mkRaw # lua
          ''
            function()
                require('dap').continue()
            end
          '';
      options.desc = "Debug: Start/Continue";
    }
    {
      mode = "n";
      key = "<F1>";
      action =
        lib.nixvim.mkRaw # lua
          ''
            function()
                require('dap').step_into()
            end
          '';
      options.desc = "Debug: Step Into";
    }
    {
      mode = "n";
      key = "<F2>";
      action =
        lib.nixvim.mkRaw # lua
          ''
            function()
                require('dap').step_over()
            end
          '';
      options.desc = "Debug: Step Over";
    }
    {
      mode = "n";
      key = "<F3>";
      action =
        lib.nixvim.mkRaw # lua
          ''
            function()
                require('dap').step_out()
            end
          '';
      options.desc = "Debug: Step Out";
    }
    {
      mode = "n";
      key = "<leader>b";
      action =
        lib.nixvim.mkRaw # lua
          ''
            function()
                require('dap').toggle_breakpoint()
            end
          '';
      options.desc = "Debug: Toggle Breakpoint";
    }
    {
      mode = "n";
      key = "<leader>B";
      action =
        lib.nixvim.mkRaw # lua
          ''
            function()
                require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
            end
          '';
      options.desc = "Debug: Set Breakpoint";
    }
    # Toggle to see last session result. Without this, you can't see session output
    # in case of unhandled exception.
    {
      mode = "n";
      key = "<F7>";
      action =
        lib.nixvim.mkRaw # lua
          ''
            function()
                require('dapui').toggle()
            end
          '';
      options.desc = "Debug: See last session result.";
    }
  ];
}

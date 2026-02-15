{
  flake.aspects.dap.nixvim =
    { lib, ... }:
    let
      mkRequire =
        func:
        lib.nixvim.mkRaw # lua
          ''
            function()
                require('dap').${func}
            end
          '';
    in
    {
      plugins = {
        dap.enable = true;
        dap-ui.enable = true;
      };

      keymaps = [
        {
          mode = "n";
          key = "<F5>";
          action = mkRequire "continue()";
          options.desc = "Debug: Start/Continue";
        }
        {
          mode = "n";
          key = "<F1>";
          action = mkRequire "step_into()";
          options.desc = "Debug: Step Into";
        }
        {
          mode = "n";
          key = "<F2>";
          action = mkRequire "step_over()";
          options.desc = "Debug: Step Over";
        }
        {
          mode = "n";
          key = "<F3>";
          action = mkRequire "step_out()";
          options.desc = "Debug: Step Out";
        }
        {
          mode = "n";
          key = "<leader>b";
          action = mkRequire "toggle_breakpoint()";
          options.desc = "Debug: Toggle Breakpoint";
        }
        {
          mode = "n";
          key = "<leader>B";
          action = mkRequire "set_breakpoint(vim.fn.input 'Breakpoint condition: ')";
          options.desc = "Debug: Set Breakpoint";
        }
        # Toggle to see last session result. Without this, you can't see session output
        # in case of unhandled exception.
        {
          mode = "n";
          key = "<F7>";
          action = mkRequire "toggle()";
          options.desc = "Debug: See last session result.";
        }
      ];
    };
}

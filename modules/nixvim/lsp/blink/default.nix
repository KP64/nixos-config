toplevel: {
  flake.modules.nixvim.blink =
    { lib, ... }:
    let
      lazyLoad.settings.event = "InsertEnter";

      mkRequire =
        func:
        lib.nixvim.mkRaw # lua
          ''
            function(ctx)
              return require("colorful-menu").${func}(ctx)
            end
          '';
    in
    {
      imports = with toplevel.config.flake.modules.nixvim; [
        blink-emoji
        blink-git
        blink-latex
      ];

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
        };

      plugins = {
        colorful-menu = {
          enable = true;
          inherit lazyLoad;
        };
        blink-cmp = {
          enable = true;
          inherit lazyLoad;
          settings = {
            keymap.preset = "super-tab";
            signature.enabled = true;
            sources.default = [
              "lsp"
              "path"
              "snippets"
              "buffer"
            ];
            completion = {
              ghost_text.enabled = true;
              menu.draw = {
                columns =
                  lib.nixvim.mkRaw # lua
                    ''{ { "kind_icon" }, { "label", gap = 1 } }'';
                components.label = {
                  text = mkRequire "blink_components_text";
                  highlight = mkRequire "blink_components_highlight";
                };
              };
            };
          };
        };
      };
    };
}

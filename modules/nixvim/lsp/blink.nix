{
  flake.modules.nixvim.blink =
    { lib, ... }:
    {
      plugins = {
        colorful-menu = {
          enable = true;
          lazyLoad.settings.event = "InsertEnter";
        };
        blink-cmp = {
          enable = true;
          lazyLoad.settings.event = "InsertEnter";
          settings = {
            keymap.preset = "super-tab";
            signature.enabled = true;
            completion = {
              documentation.auto_show = true;
              menu.draw = {
                columns =
                  lib.nixvim.mkRaw # lua
                    ''{ { "kind_icon" }, { "label", gap = 1 } }'';
                components.label = {
                  text =
                    lib.nixvim.mkRaw # lua
                      ''
                        function(ctx)
                          return require("colorful-menu").blink_components_text(ctx)
                        end
                      '';
                  highlight =
                    lib.nixvim.mkRaw # lua
                      ''
                        function(ctx)
                          return require("colorful-menu").blink_components_highlight(ctx)
                        end
                      '';
                };
              };
            };
          };
        };
      };
    };
}

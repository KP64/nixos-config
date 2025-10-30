{
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
      dependencies = {
        curl.enable = true;
        git.enable = true;
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
            completion = {
              documentation.auto_show = true;
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

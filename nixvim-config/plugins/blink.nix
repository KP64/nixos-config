{ lib, pkgs, ... }:
{
  extraPackages = [ pkgs.glab ];
  dependencies = {
    git.enable = true;
    gh.enable = true;
  };

  # TODO: LazyLoad
  plugins = {
    colorful-menu.enable = true;
    # FIX: Rust "from" shows git stuff instead of conversions
    blink-cmp-git.enable = true;
    blink-ripgrep.enable = true;
    blink-cmp = {
      enable = true;
      lazyLoad.settings.event = "InsertEnter";
      settings = {
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
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "git"
            "ripgrep"
          ];
          providers = {
            git = {
              module = "blink-cmp-git";
              name = "git";
              score_offset = 100;
            };
            ripgrep = {
              async = true;
              module = "blink-ripgrep";
              name = "Ripgrep";
              score_offset = 100;
              opts = {
                prefix_min_len = 3;
                context_size = 5;
                max_filesize = "1M";
                project_root_marker = ".git";
                project_root_fallback = true;
                search_casing = "--ignore-case";
                fallback_to_regex_highlighting = true;
              };
            };
          };
        };
      };
    };
  };
}

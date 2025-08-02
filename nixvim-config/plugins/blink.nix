{ lib, pkgs, ... }:
{
  extraPackages = [ pkgs.glab ];
  dependencies = {
    git.enable = true;
    gh.enable = true;
  };

  plugins = {
    colorful-menu.enable = true;
    blink-cmp-git.enable = true;
    blink-ripgrep.enable = true;
    # TODO: Rust fuzzy implementation
    blink-cmp = {
      enable = true;
      settings = {
        signature.enabled = true;
        completion = {
          documentation.auto_show = true; # TODO: Disable if annoying
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

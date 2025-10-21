{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt = {
    settings.global.excludes = [ "*secrets.yaml" ];
    programs = {
      # Just
      just.enable = true;

      # ❄️ Nix
      deadnix.enable = true;
      statix.enable = true;
      nixf-diagnose.enable = true;
      nixfmt = {
        enable = true;
        strict = true;
      };

      # PNG
      oxipng = {
        enable = true;
        opt = "max";
        strip = "safe";
      };

      # 🐚 Shell
      shfmt.enable = true;
      shellcheck.enable = true;

      # [T] TOML
      taplo.enable = true;
      toml-sort.enable = true;

      # 🪐 Lua
      stylua = {
        enable = true;
        settings = {
          indent_type = "Spaces";
          sort_requires.enabled = true;
        };
      };

      # Multiple
      prettier = {
        enable = true;
        settings.overrides = [
          {
            files = [ "*.svg" ];
            options.parser = "html";
          }
        ];
        includes = [
          "*.json"
          "*.md"
          "*.yaml"
          "*.yml"
          "*.svg"
        ];
      };
      typos = {
        enable = true;
        sort = true;
        isolated = true;
        configFile = builtins.path { path = inputs.self + /typos.toml; };
      };
    };
  };
}

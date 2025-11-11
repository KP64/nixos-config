{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        settings = {
          global.excludes = [ "*secrets.yaml" ];
          formatter."svg-optimizer" = {
            command = pkgs.writeShellApplication {
              name = "svg-optimizer";
              runtimeInputs = with pkgs; [
                scour
                svgo
              ];
              # Intermediary file is unfortunately needed
              text = ''
                for file in "$@"; do
                  scour --enable-viewboxing -i "$file" -o tmp.svg
                  svgo -i tmp.svg -o "$file"
                done
                rm tmp.svg
              '';
            };
            includes = [ "*.svg" ];
          };
        };
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
          prettier.enable = true;
          typos = {
            enable = true;
            sort = true;
            isolated = true;
            configFile = builtins.path { path = inputs.self + /typos.toml; };
          };
        };
      };
    };
}

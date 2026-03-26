toplevel@{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    {
      lib,
      pkgs,
      inputs',
      ...
    }:
    let
      tomlFormat = pkgs.formats.toml { };

      inherit (toplevel.config.lib.flake.util) getSopsFiles mapIfAvailable;

      getConfigs = toplevelConfig: toplevelConfig |> builtins.attrValues |> map (topconf: topconf.config);
      nixosConfigs = getConfigs toplevel.config.flake.nixosConfigurations;
      hmConfigs = getConfigs toplevel.config.flake.homeConfigurations;

      getRelativePath =
        paths: paths |> map (p: p |> toString |> builtins.match ".*(modules/.*)" |> builtins.head);

      nixosUserHmConfigs =
        nixosConfigs
        |> mapIfAvailable {
          needs = "home-manager";
          extraAccess = [ "users" ];
        }
        |> map builtins.attrValues
        |> lib.flatten;

      facterFiles =
        nixosConfigs
        |> map (c: c.hardware.facter.reportPath)
        |> builtins.filter (p: p != null)
        |> getRelativePath;

      hostSopsFiles =
        nixosConfigs
        |> mapIfAvailable {
          needs = "sops";
          extraAccess = [ "secrets" ];
        }
        |> map getSopsFiles
        |> lib.flatten
        |> getRelativePath;

      getHmUserSopsFiles =
        hmConfig:
        hmConfig
        |> lib.filter (user: user ? sops)
        |> map (user: user.sops.secrets)
        |> map getSopsFiles
        |> lib.flatten
        |> getRelativePath;
    in
    {
      treefmt = {
        settings = {
          global.excludes = lib.unique (
            (getHmUserSopsFiles nixosUserHmConfigs) ++ (getHmUserSopsFiles hmConfigs) ++ hostSopsFiles
          );
          formatter = {
            svg-optimizer = {
              command = pkgs.writeShellApplication {
                name = "svg-optimizer";
                runtimeInputs = with pkgs; [
                  scour
                  svgo
                ];
                # Intermediary file is unfortunately needed
                text = ''
                  for file in "$@"; do
                    # Save original timestamp
                    ts="$(stat -c %y "$file")"

                    tmp="$(mktemp)"

                    scour --enable-viewboxing -i "$file" -o "$tmp"
                    svgo --multipass -i "$tmp" -o "$tmp"

                    if ! cmp -s "$file" "$tmp"; then
                      mv "$tmp" "$file"
                    else
                      rm "$tmp"
                    fi

                    # Restore timestamp
                    touch -d "$ts" "$file"
                  done
                '';
              };
              includes = [ "*.svg" ];
            };
            nufmt = {
              command = lib.getExe' inputs'.nufmt.packages.default "nufmt";
              includes = [ "*.nu" ];
            };
          };
        };
        programs = {
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

          qmlformat.enable = true;

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
            configFile = toString (
              tomlFormat.generate "typos" {
                default.extend-words = lib.genAttrs [
                  "enew"
                  "ede"
                  "facter"
                  "noice"
                  "HAE" # LTT Channel ID
                ] (name: name);
                files.extend-exclude = facterFiles;
              }
            );
          };
        };
      };
    };
}

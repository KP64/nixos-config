toplevel@{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { lib, pkgs, ... }:
    let
      tomlFormat = pkgs.formats.toml { };

      inherit (toplevel.config.lib.flake.util) getRelativePath;

      getConfigs = toplevelConfig: toplevelConfig |> builtins.attrValues |> map (topconf: topconf.config);
      nixosConfigs = getConfigs toplevel.config.flake.nixosConfigurations;
      hmConfigs = getConfigs toplevel.config.flake.homeConfigurations;

      nixosUserHmConfigs =
        nixosConfigs
        |> map (cfg: cfg.home-manager.users)
        |> map builtins.attrValues
        |> lib.flatten;

      facterFiles =
        nixosConfigs
        |> map (c: c.hardware.facter.reportPath)
        |> builtins.filter (p: p != null)
        |> map getRelativePath;

      getSecretsPaths =
        secrets:
        secrets
        |> map builtins.attrValues
        |> lib.flatten
        |> map (secret: secret.sopsFile)
        |> map getRelativePath;

      getSopsFiles = cfg: cfg |> map (cfg: cfg.sops.secrets) |> getSecretsPaths;
    in
    {
      treefmt = {
        settings = {
          global.excludes = lib.unique (
            (getSopsFiles nixosConfigs) ++ (getSopsFiles nixosUserHmConfigs) ++ (getSopsFiles hmConfigs)
          );
          formatter = {
            svg-optimizer =
              let
                filetype = "svg";
              in
              {
                command =
                  pkgs.writers.writeNuBin "${filetype}-optimizer" # nu
                    ''
                      def main [...files: string]: nothing -> nothing {
                          for file in $files {
                              let tmp = mktemp --suffix .${filetype}

                              ${lib.getExe pkgs.scour} --enable-viewboxing -i $file -o $tmp
                              ${lib.getExe pkgs.svgo} --multipass -i $tmp -o $tmp

                              let is_changed = (${lib.getExe' pkgs.uutils-diffutils "cmp"} $file $tmp | complete | get exit_code) != 0
                              if $is_changed {
                                  mv -f $tmp $file
                              } else {
                                  rm -p $tmp
                              }
                          }
                      }
                    '';
                includes = [ "*.${filetype}" ];
              };
            # TODO: Remove once nufmt is back in treefmt-nix
            #        - https://github.com/numtide/treefmt-nix/pull/489
            #        - https://github.com/numtide/treefmt-nix/pull/510
            nufmt = {
              command = pkgs.nufmt;
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

          # 🖼️ PNG
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
            configFile = toString (
              tomlFormat.generate "typos" {
                default.extend-words = lib.flip lib.genAttrs (w: w) [
                  "enew"
                  "facter"
                  "noice"
                  "HAE" # LTT Channel ID
                  "ND" # navidrome.env sops content
                ];
                files.extend-exclude = facterFiles;
              }
            );
          };
        };
      };
    };
}

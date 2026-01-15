{
  config,
  customLib,
  inputs,
  ...
}:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { lib, pkgs, ... }:
    let
      tomlFormat = pkgs.formats.toml { };

      getConfigs = toplevelConfig: toplevelConfig |> builtins.attrValues |> map (topconf: topconf.config);
      nixosConfigs = getConfigs config.flake.nixosConfigurations;
      hmConfigs = getConfigs config.flake.homeConfigurations;

      getRelativePath =
        paths: paths |> map (p: p |> toString |> builtins.match ".*(modules/.*)") |> map builtins.head;

      nixosUserHmConfigs =
        nixosConfigs
        |> customLib.util.mapIfAvailable {
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
        |> customLib.util.mapIfAvailable {
          needs = "sops";
          extraAccess = [ "secrets" ];
        }
        |> map customLib.util.getSopsFiles
        |> lib.flatten
        |> getRelativePath;

      getHmUserSopsFiles =
        hmConfig:
        hmConfig
        |> lib.filter (user: user ? sops)
        |> map (user: user.sops.secrets)
        |> map customLib.util.getSopsFiles
        |> lib.flatten
        |> getRelativePath;
    in
    {
      treefmt = {
        settings = {
          global.excludes =
            lib.unique
            <| (getHmUserSopsFiles nixosUserHmConfigs) ++ (getHmUserSopsFiles hmConfigs) ++ hostSopsFiles;
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
                  svgo --multipass -i tmp.svg -o "$file"
                done
                rm tmp.svg
              '';
            };
            includes = [ "*.svg" ];
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
            configFile =
              toString
              <| tomlFormat.generate "typos" {
                default.extend-words = {
                  ede = "ede";
                  facter = "facter";
                  nitch = "nitch";
                  noice = "noice";
                  HAE = "HAE"; # LTT Channel ID
                };
                files.extend-exclude = facterFiles;
              };
          };
        };
      };
    };
}

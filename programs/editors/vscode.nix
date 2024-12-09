{
  pkgs,
  lib,
  config,
  inputs,
  username,
  collectLastEntries,
  appendLastWithFullPath,
  ...
}:

let
  inherit (inputs.nix-vscode-extensions.extensions.${pkgs.system}) vscode-marketplace;
in
{
  options.editors.vscode.enable = lib.mkEnableOption "Vscode";

  config = lib.mkIf config.editors.vscode.enable {
    home-manager.users.${username}.programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions =
        (with vscode-marketplace; [
          jscearcy.rust-doc-viewer
          miguelsolorio.fluent-icons
          rszyma.vscode-kanata
          vivaxy.vscode-conventional-commits
        ])
        ++ (
          with pkgs.vscode-extensions;
          [
            aaron-bond.better-comments
            bradlc.vscode-tailwindcss
            charliermarsh.ruff
            christian-kohler.path-intellisense
            donjayamanne.githistory
            eamodio.gitlens
            esbenp.prettier-vscode
            fill-labs.dependi
            github.vscode-pull-request-github
            gruntfuggly.todo-tree
            jnoortheen.nix-ide
            jock.svg
            mhutchie.git-graph
            mkhl.direnv
            ms-azuretools.vscode-docker
            nefrob.vscode-just-syntax
            rust-lang.rust-analyzer
            svelte.svelte-vscode
            tamasfe.even-better-toml
            tauri-apps.tauri-vscode
            thenuprojectcontributors.vscode-nushell-lang
            usernamehw.errorlens
            vadimcn.vscode-lldb
            waderyan.gitblame
            wix.vscode-import-cost
          ]
          ++ (with ms-toolsai; [
            jupyter-renderers
            jupyter-keymap
            jupyter
          ])
          ++ (with ms-python; [
            black-formatter
            python
          ])
          ++ (with catppuccin; [
            catppuccin-vsc
            catppuccin-vsc-icons
          ])
          ++ (with ms-vscode; [
            cpptools-extension-pack
            makefile-tools
          ])
          ++ (with visualstudioexptteam; [
            intellicode-api-usage-examples
            vscodeintellicode
          ])
        );
      languageSnippets.toml.lint = {
        body = [
          "[lints.rust]"
          ''unsafe-code = "forbid"''
          ""
          "[lints.clippy]"
          ''pedantic = "warn"''
          ''nursery = "warn"''
          ''cargo = "warn"''
        ];
        description = "Lint your Rust Project to the Max";
        prefix = [ "lint" ];
      };

      userSettings =
        (collectLastEntries (appendLastWithFullPath {
          extensions = {
            autoCheckUpdates = false;
            autoUpdate = false;
          };

          workbench = {
            iconTheme = "catppuccin-mocha";
            colorTheme = "Catppuccin Mocha";
            productIconTheme = "fluent-icons";
            startupEditor = "none";
          };

          files = {
            autoSave = "afterDelay";
            trimTrailingWhitespace = true;
          };

          editor = {
            fontFamily = "JetBrainsMono Nerd Font";
            fontLigatures = true;
            guides.bracketPairs = "active";
            formatOnSave = true;
            minimap.autohide = true;
          };

          rust-analyzer.check.command = "clippy";
          svelte.enable-ts-plugin = true;
          git.autofetch = true;
          telemetry.telemetryLevel = "off";
          gitlens.telemetry.enabled = false;
          terminal.integrated.defaultProfile.linux = "Nushell";
          update.showReleaseNotes = false;
        }))
        // {
          "[python]" = {
            "editor.defaultFormatter" = "ms-python.black-formatter";
          };
        }
        //
          lib.genAttrs
            (map (lang: "[${lang}]") [
              "javascript"
              "typescript"
              "json"
              "jsonc"
              "css"
              "html"
              "svelte"
            ])
            (_: {
              "editor.defaultFormatter" = "esbenp.prettier-vscode";
            });
    };
  };
}

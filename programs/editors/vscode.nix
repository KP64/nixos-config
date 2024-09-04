{
  pkgs,
  lib,
  config,
  inputs,
  username,
  collectLastEntries,
  replaceLastWithFullPath,
  ...
}:

{
  options.editors.vscode.enable = lib.mkEnableOption "Enable Vscode Editor";

  config = lib.mkIf config.editors.vscode.enable {
    home-manager.users.${username}.programs.vscode = {
      enable = true;
      extensions =
        with pkgs.vscode-extensions;
        [
          wix.vscode-import-cost
          waderyan.gitblame
          vscode-icons-team.vscode-icons
          visualstudioexptteam.vscodeintellicode
          visualstudioexptteam.intellicode-api-usage-examples
          vadimcn.vscode-lldb
          ms-vscode.cpptools-extension-pack
          usernamehw.errorlens
          thenuprojectcontributors.vscode-nushell-lang
          tamasfe.even-better-toml
          svelte.svelte-vscode
          ms-azuretools.vscode-docker
          mkhl.direnv
          esbenp.prettier-vscode
          eamodio.gitlens
          mhutchie.git-graph
          donjayamanne.githistory
          bradlc.vscode-tailwindcss
          jnoortheen.nix-ide
          aaron-bond.better-comments
          gruntfuggly.todo-tree
          fill-labs.dependi
          rust-lang.rust-analyzer
          christian-kohler.path-intellisense
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
        ]
        ++ (with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
          miguelsolorio.fluent-icons
          jscearcy.rust-doc-viewer
          vivaxy.vscode-conventional-commits
        ]);
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
        (collectLastEntries (replaceLastWithFullPath {
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
          terminal.integrated.defaultProfile.linux = "Nushell";
        }))
        // lib.genAttrs
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

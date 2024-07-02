{
  pkgs,
  lib,
  config,
  inputs,
  username,
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
          serayuzgur.crates
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

      userSettings = {
        "workbench.iconTheme" = "catppuccin-mocha";
        "workbench.productIconTheme" = "fluent-icons";
        "workbench.startupEditor" = "none";
        "files.autoSave" = "afterDelay";
        "editor.fontFamily" = "JetBrainsMono Nerd Font";
        "editor.fontLigatures" = true;
        "workbench.colorTheme" = "Catppuccin Mocha";
        "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.formatOnSave" = true;
        "editor.minimap.autohide" = true;
        "files.autoSaveWhenNoErrors" = true;
        "files.trimTrailingWhitespace" = true;
        "rust-analyzer.check.command" = "clippy";
        "git.autofetch" = true;
        "telemetry.telemetryLevel" = "off";
        "terminal.integrated.defaultProfile.linux" = "Nushell";
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[css]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[html]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[svelte]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
      };
    };
  };
}

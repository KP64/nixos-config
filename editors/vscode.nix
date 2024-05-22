{ pkgs, inputs, ... }:

{
  services.gnome-keyring.enable = true;
  programs.vscode = {
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
        usernamehw.errorlens
        thenuprojectcontributors.vscode-nushell-lang
        tamasfe.even-better-toml
        svelte.svelte-vscode
        ms-azuretools.vscode-docker
        mkhl.direnv
        esbenp.prettier-vscode
        eamodio.gitlens
        catppuccin.catppuccin-vsc
        bradlc.vscode-tailwindcss
        bbenoist.nix
        aaron-bond.better-comments
        gruntfuggly.todo-tree
        ms-vscode.cmake-tools
      ]
      ++ (with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
        rust-lang.rust-analyzer
        miguelsolorio.fluent-icons
        jscearcy.rust-doc-viewer
        serayuzgur.crates

        # Icons weren't included in pack for whatever reason
        catppuccin.catppuccin-vsc-icons
        catppuccin.catppuccin-vsc-pack
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
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
    };
  };
}

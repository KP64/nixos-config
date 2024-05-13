{ pkgs, inputs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
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
      ]
      ++ (with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
        rust-lang.rust-analyzer
        miguelsolorio.fluent-icons
        jscearcy.rust-doc-viewer
        serayuzgur.crates
      ]);
    languageSnippets = {
      toml = {
        lint = {
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
      };
    };
    # VScode uses US Layout (z and y are swapped)
    # Remove keybindings when using US Layout Keyboards
    keybindings = [
      {
        key = "ctrl+shift+z";
        command = "redo";
      }
      {
        key = "crtl+z";
        command = "undo";
      }
      {
        key = "ctrl+y";
        command = "redo";
      }
      {
        key = "ctrl+y";
        command = "workbench.debug.action.toggleRepl";
        when = "workbench.panel.repl.view.active";
      }
    ];

    userSettings = {
      "workbench.iconTheme" = "vscode-icons";
      "workbench.productIconTheme" = "fluent-icons";
      "workbench.startupEditor" = "none";
      "files.autoSave" = "afterDelay";
      "editor.fontFamily" = "JetBrainsMono Nerd Font";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
      "editor.guides.bracketPairs" = "active";
      "editor.formatOnSave" = true;
      "editor.minimap.autohide" = true;
      "files.autoSaveWhenNoErrors" = true;
      "files.trimTrailingWhitespace" = true;
      "rust-analyzer.check.command" = "clippy";
      "git.autofetch" = true;
    };
  };
}

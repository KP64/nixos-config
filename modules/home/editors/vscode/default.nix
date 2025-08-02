{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  inherit (inputs.nix-vscode-extensions.extensions.${pkgs.system}) vscode-marketplace;
  cfg = config.editors.vscode;
in
{
  imports =
    (map (p: import p vscode-marketplace) [
      ./rust
      ./fluent-icons.nix
      ./tabby.nix
    ])
    ++ [
      ./catppuccin.nix
      ./git.nix
      ./prettier.nix
      ./python.nix
      ./svelte.nix
    ];

  options.editors.vscode.enable = lib.mkEnableOption "Vscode";

  config.programs.vscode = {
    inherit (cfg) enable;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions =
        (with vscode-marketplace; [
          rszyma.vscode-kanata
          vivaxy.vscode-conventional-commits
        ])
        ++ (
          with pkgs.vscode-extensions;
          [
            aaron-bond.better-comments
            bradlc.vscode-tailwindcss
            christian-kohler.path-intellisense
            fill-labs.dependi
            gruntfuggly.todo-tree
            jnoortheen.nix-ide
            jock.svg
            mkhl.direnv
            ms-azuretools.vscode-docker
            myriad-dreamin.tinymist
            nefrob.vscode-just-syntax
            tamasfe.even-better-toml
            tauri-apps.tauri-vscode
            thenuprojectcontributors.vscode-nushell-lang
            usernamehw.errorlens
            vadimcn.vscode-lldb
            wix.vscode-import-cost
          ]
          ++ (with ms-vscode; [
            cpptools-extension-pack
            makefile-tools
          ])
          ++ (with visualstudioexptteam; [
            intellicode-api-usage-examples
            vscodeintellicode
          ])
        );

      userSettings =
        lib.custom.collectLastEntries
        <| lib.custom.appendLastWithFullPath
        <| {
          workbench.startupEditor = "none";

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

          telemetry.telemetryLevel = "off";
          update.showReleaseNotes = false;
        };
    };
  };
}

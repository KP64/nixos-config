{ lib, pkgs, ... }:
{
  programs.vscode.profiles.default = {
    extensions = [ pkgs.vscode-extensions.esbenp.prettier-vscode ];

    userSettings =
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
}

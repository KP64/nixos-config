vscode-marketplace:
{ lib, pkgs, ... }:
{
  programs.vscode.profiles.default = {
    extensions = [
      pkgs.vscode-extensions.rust-lang.rust-analyzer
      vscode-marketplace.jscearcy.rust-doc-viewer
    ];

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
      {
        rust-analyzer.check.command = "clippy";
      }
      |> lib.custom.appendLastWithFullPath
      |> lib.custom.collectLastEntries;
  };
}

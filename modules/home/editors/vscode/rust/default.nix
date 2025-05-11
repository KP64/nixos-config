vscode-marketplace:
{ lib, pkgs, ... }:
let
  importLint = path: path |> builtins.readFile |> lib.splitString "\n";

  getMaximized =
    name: lints:
    lints
    |> lib.importTOML
    |> lib.recursiveUpdate (lib.importTOML ./lints/max/common.toml)
    |> pkgs.writers.writeTOML "rs-lints-${name}";
in
{
  programs.vscode.profiles.default = {
    extensions = [
      pkgs.vscode-extensions.rust-lang.rust-analyzer
      vscode-marketplace.jscearcy.rust-doc-viewer
    ];

    languageSnippets.toml = {
      lint = {
        body = importLint ./lints/simple.toml;
        description = "Lint your Rust Project";
        prefix = [ "lint" ];
      };

      lintMaxSafe = {
        body = importLint (getMaximized "safe" ./lints/max/safe.toml);
        description = "Don't. Unless you have some screws loose";
        prefix = [ "lint_max_s" ];
      };

      lintMaxUnsafe = {
        body = importLint (getMaximized "unsafe" ./lints/max/unsafe.toml);
        description = "Same as maxlint but allows unsafe code";
        prefix = [ "lint_max_u" ];
      };
    };

    userSettings =
      {
        rust-analyzer.check.command = "clippy";
      }
      |> lib.custom.appendLastWithFullPath
      |> lib.custom.collectLastEntries;
  };
}

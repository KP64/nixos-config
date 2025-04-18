{ lib, pkgs, ... }:
{
  programs.vscode.profiles.default = {
    extensions = [ pkgs.vscode-extensions.svelte.svelte-vscode ];

    userSettings =
      {
        svelte.enable-ts-plugin = true;
      }
      |> lib.custom.appendLastWithFullPath
      |> lib.custom.collectLastEntries;
  };
}

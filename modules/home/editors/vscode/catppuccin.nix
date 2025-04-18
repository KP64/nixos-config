{
  config,
  lib,
  pkgs,
  ...
}:
# TODO: Remove once https://github.com/catppuccin/nix/issues/518 is closed.
{
  programs.vscode.profiles.default = {
    extensions = [ pkgs.vscode-extensions.catppuccin.catppuccin-vsc-icons ];

    userSettings =
      {
        workbench.iconTheme = "catppuccin-mocha";
      }
      |> lib.optionalAttrs config.isCatppuccinEnabled
      |> lib.custom.appendLastWithFullPath
      |> lib.custom.collectLastEntries;
  };
}

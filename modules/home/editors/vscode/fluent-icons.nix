vscode-marketplace:
{ lib, ... }:
{
  programs.vscode.profiles.default = {
    extensions = [ vscode-marketplace.miguelsolorio.fluent-icons ];

    userSettings =
      {
        workbench.productIconTheme = "fluent-icons";
      }
      |> lib.custom.appendLastWithFullPath
      |> lib.custom.collectLastEntries;
  };
}

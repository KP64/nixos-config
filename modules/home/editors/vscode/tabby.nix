vscode-marketplace:
{ lib, ... }:
{
  programs.vscode.profiles.default = {
    extensions = [ vscode-marketplace.tabbyml.vscode-tabby ];

    userSettings =
      {
        tabby.endpoint = "https://tabby.holab.ipv64.de";
      }
      |> lib.custom.appendLastWithFullPath
      |> lib.custom.collectLastEntries;
  };
}

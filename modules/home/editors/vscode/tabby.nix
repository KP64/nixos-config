vscode-marketplace:
{ lib, ... }:
{
  programs.vscode.profiles.default = {
    extensions = [ vscode-marketplace.tabbyml.vscode-tabby ];

    userSettings =
      {
        tabby = {
          # TODO: Check how it is disabled
          config.telemetry = true;
          endpoint = "https://tabby.holab.ipv64.de";
        };
      }
      |> lib.custom.appendLastWithFullPath
      |> lib.custom.collectLastEntries;
  };
}

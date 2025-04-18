vscode-marketplace:
{ lib, ... }:
{
  programs.vscode.profiles.default = {
    extensions = [ vscode-marketplace.tabbyml.vscode-tabby ];

    userSettings =
      {
        tabby = {
          # Confusing but this actually disables it
          config.telemetry = true;
          endpoint = "https://tabby.nix-pi.ipv64.de";
        };
      }
      |> lib.custom.appendLastWithFullPath
      |> lib.custom.collectLastEntries;
  };
}

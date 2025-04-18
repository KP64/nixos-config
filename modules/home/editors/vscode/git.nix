{ lib, pkgs, ... }:
{
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      donjayamanne.githistory
      eamodio.gitlens
      github.vscode-pull-request-github
      mhutchie.git-graph
      waderyan.gitblame
    ];

    userSettings =
      {
        git.autofetch = true;
        gitlens.telemetry.enabled = false;
      }
      |> lib.custom.appendLastWithFullPath
      |> lib.custom.collectLastEntries;
  };
}

{ pkgs, ... }:
{
  programs.vscode.profiles.default = {
    extensions =
      with pkgs.vscode-extensions;
      [
        ms-python.python
        charliermarsh.ruff
      ]
      ++ (with ms-toolsai; [
        jupyter-renderers
        jupyter-keymap
        jupyter
      ]);

    userSettings."[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
  };
}

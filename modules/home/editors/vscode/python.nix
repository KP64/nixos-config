{ pkgs, ... }:
# TODO: Remove once https://github.com/catppuccin/nix/issues/518 is closed.
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

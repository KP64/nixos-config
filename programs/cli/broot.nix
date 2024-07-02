{ username, ... }:
{
  # TODO: Change Colors to Catppuccin
  home-manager.users.${username}.programs.broot = {
    enable = true;
    settings.verbs = [
      {
        invocation = "edit";
        key = "F2";
        shortcut = "e";
        apply_to = "file";
        external = "$EDITOR {file}";
        leave_broot = false;
      }
    ];
  };
}

# TODO: Change Colors to Catppuccin
{ username, ... }:
{
  home-manager.users.${username}.programs.broot = {
    enable = true;
    settings.verbs = [
      {
        invocation = "edit";
        key = "F2";
        shortcut = "e";
        apply_to = "file";
        external = "hx {file}";
        leave_broot = false;
      }
    ];
  };
}

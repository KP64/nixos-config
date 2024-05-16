catppuccin:
{ ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    inherit catppuccin;
    settings.editor.cursor-shape = {
      insert = "bar";
      normal = "block";
      select = "underline";
    };
  };
}

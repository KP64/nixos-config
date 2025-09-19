{
  flake.modules.homeManager.users-kg = {
    programs.helix = {
      enable = true;
      settings.editor = {
        true-color = true;
        file-picker.hidden = false;
        lsp.display-inlay-hints = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  };
}

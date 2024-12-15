{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.editors.helix;
in
{
  options.editors.helix.enable = lib.mkEnableOption "Helix";

  config.home-manager.users.${username}.programs.helix = {
    inherit (cfg) enable;
    defaultEditor = true;
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
    languages = {
      language-server.nixd.command = "nixd";
      language = [
        {
          name = "nix";
          language-servers = [
            "nixd"
            "nil"
          ];
          auto-format = true;
          formatter.command = "nix fmt";
        }
      ];
    };
  };
}

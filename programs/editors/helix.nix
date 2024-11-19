{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  options.editors.helix.enable = lib.mkEnableOption "Enable Helix Editor";

  config = lib.mkIf config.editors.helix.enable {
    home-manager.users.${username}.programs.helix = {
      enable = true;
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
  };
}

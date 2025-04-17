{ config, lib, ... }:
let
  cfg = config.editors.helix;
in
{
  options.editors.helix.enable = lib.mkEnableOption "Helix";

  config.programs.helix = {
    inherit (cfg) enable;
    # TODO: Make neovim defaultEditor when ready.
    defaultEditor = true;
    settings = lib.mkDefault {
      editor = {
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

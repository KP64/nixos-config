{ config, lib, ... }:
let
  cfg = config.editors.helix;
in
{
  options.editors.helix.enable = lib.mkEnableOption "Helix";

  config.programs.helix = {
    inherit (cfg) enable;
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
      language-server = {
        just-lsp.command = "just-lsp";
        nixd.command = "nixd";
      };
      language = [
        {
          name = "just";
          language-servers = [ "just-lsp" ];
        }
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

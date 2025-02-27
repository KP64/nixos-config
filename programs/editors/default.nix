{ config, lib, ... }:
let
  cfg = config.editors;
in
{
  imports = [
    ./aseprite.nix
    ./blender.nix
    ./helix.nix
    ./imhex.nix
    ./neovim.nix
    ./vscode.nix
    ./zed.nix
  ];

  options.editors.enable = lib.mkEnableOption "Editors";

  config.editors = lib.mkIf cfg.enable {
    aseprite.enable = lib.mkDefault true;
    blender.enable = lib.mkDefault true;
    helix.enable = lib.mkDefault true;
    imhex.enable = lib.mkDefault true;
    neovim.enable = lib.mkDefault true;
    vscode.enable = lib.mkDefault true;
    zed.enable = lib.mkDefault true;
  };
}

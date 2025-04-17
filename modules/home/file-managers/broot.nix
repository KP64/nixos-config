{ config, lib, ... }:
let
  cfg = config.file-managers.broot;
in
{
  # TODO: Catppuccin theme
  options.file-managers.broot.enable = lib.mkEnableOption "Broot";

  config.programs.broot = { inherit (cfg) enable; };
}

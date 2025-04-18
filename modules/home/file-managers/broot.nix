{ config, lib, ... }:
let
  cfg = config.file-managers.broot;
in
{
  options.file-managers.broot.enable = lib.mkEnableOption "Broot";

  config.programs.broot = {
    inherit (cfg) enable;
    settings.modal = true;
  };
}

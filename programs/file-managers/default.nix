{ config, lib, ... }:
let
  cfg = config.file-managers;
in
{
  imports = [
    ./broot.nix
    ./thunar.nix
    ./yazi.nix
  ];

  options.file-managers.enable = lib.mkEnableOption "File-Managers";

  config.file-managers = lib.mkIf cfg.enable {
    broot.enable = lib.mkDefault true;
    thunar.enable = lib.mkDefault true;
    yazi.enable = lib.mkDefault true;
  };
}

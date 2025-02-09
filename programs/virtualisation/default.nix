{ config, lib, ... }:
let
  cfg = config.virt;
in
{
  imports = [
    ./docker.nix
    ./podman.nix
    ./virtualbox.nix
  ];

  options.virt.enable = lib.mkEnableOption "Virtualisation";

  config.virt = lib.mkIf cfg.enable { docker.enable = lib.mkDefault true; };
}

{ config, lib, ... }:
let
  cfg = config.cli.shells;
in
{
  imports = [
    ./nushell
    ./bash.nix
  ];

  options.cli.shells.enable = lib.mkEnableOption "Cli Shells";

  config.cli.shells = lib.mkIf cfg.enable {
    bash.enable = lib.mkDefault true;
    nushell.enable = lib.mkDefault true;
  };
}

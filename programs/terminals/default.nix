{ config, lib, ... }:
let
  cfg = config.terminals;
in
{
  imports = [ ./kitty.nix ];

  options.terminals.enable = lib.mkEnableOption "Terminal Emulators";

  config.terminals = lib.mkIf cfg.enable {
    kitty.enable = lib.mkDefault true;
  };
}

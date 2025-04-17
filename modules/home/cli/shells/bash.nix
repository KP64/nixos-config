{ config, lib, ... }:
let
  cfg = config.cli.shells.bash;
in
{
  options.cli.shells.bash.enable = lib.mkEnableOption "Bash";

  config.programs.bash = { inherit (cfg) enable; };
}

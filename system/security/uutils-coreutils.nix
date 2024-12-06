{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.system.security.uutils-coreutils.enable =
    lib.mkEnableOption "Rust rewrite of GNU Coreutils";

  config = lib.mkIf config.system.security.uutils-coreutils.enable {
    # commands are uutils-{command} by default
    # *-noprefix removes uutils- prefix (replaces GNU Coreutils)
    # e.g.:
    # with    prefix: uutils-mv
    # without prefix: mv
    environment.systemPackages = [ pkgs.uutils-coreutils-noprefix ];
  };
}

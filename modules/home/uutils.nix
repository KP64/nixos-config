{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.uutils;
in
{
  options.uutils.enable = lib.mkEnableOption "unstable rust GNU utils rewrite";

  # commands are uutils-{command} by default
  # *-noprefix removes uutils- prefix (replaces GNU Coreutils)
  # e.g.:
  # with    prefix: uutils-mv
  # without prefix: mv
  config.home.packages =
    [ pkgs.uutils-coreutils-noprefix ]
    ++ (lib.optionals cfg.enable (
      with pkgs;
      [
        uutils-diffutils
        uutils-findutils
      ]
    ));
}

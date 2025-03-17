{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.system.security.uutils;
in
{
  options.system.security.uutils = {
    enable = lib.mkEnableOption "Rust rewrite of GNU coreutils";
    extras.enable = lib.mkEnableOption "Rust rewrite of GNU diff & findutils";
  };

  config = lib.mkIf cfg.enable {
    # commands are uutils-{command} by default
    # *-noprefix removes uutils- prefix (replaces GNU Coreutils)
    # e.g.:
    # with    prefix: uutils-mv
    # without prefix: mv
    environment.systemPackages =
      [ pkgs.uutils-coreutils-noprefix ]
      ++ (lib.optionals cfg.extras.enable (
        with pkgs;
        [
          uutils-diffutils
          uutils-findutils
        ]
      ));
  };
}

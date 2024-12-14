{
  config,
  lib,
  stable-pkgs,
  ...
}:
let
  cfg = config.services.media.immich;
in
{
  options.services.media.immich = {
    enable = lib.mkEnableOption "Immich";

    host = lib.mkOption {
      readOnly = true;
      type = lib.types.nonEmptyStr;
      description = "The ip on which immich is served.";
      example = "192.168.2.5";
    };

    secretsFile = lib.mkOption {
      default = null;
      type = lib.types.path;
    };
  };

  config = lib.mkMerge [
    {
      services.immich = {
        inherit (cfg) enable secretsFile host;
        package = stable-pkgs.immich;
        openFirewall = true;
        machine-learning.enable = true;
      };
    }

    (lib.mkIf config.system.impermanence.enable {
      environment.persistence."/persist".directories = lib.optional cfg.enable "/var/lib/immich";
    })
  ];
}

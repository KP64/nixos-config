{ config, lib, ... }:
let
  cfg = config.services.ai.open-webui;
in
{
  options.services.ai.open-webui.enable = lib.mkEnableOption "Open-Webui";

  config = lib.mkMerge [
    {
      services.open-webui = {
        inherit (cfg) enable;
        host = "0.0.0.0";
        port = 11111;
        openFirewall = true;
      };
    }

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories =
        lib.optional cfg.enable "/var/lib/private/open-webui";
    })
  ];
}

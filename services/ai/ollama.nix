{ config, lib, ... }:
let
  cfg = config.services.ai.ollama;
in
{
  options.services.ai.ollama = {
    enable = lib.mkEnableOption "Ollama";

    acceleration = lib.mkOption {
      readOnly = true;
      type = lib.types.enum [
        "cpu"
        "cuda"
        "rocm"
      ];
      example = "cpu";
      description = "Whether to use the GPU or CPU";
    };

    models = lib.mkOption {
      readOnly = true;
      type = with lib.types; nonEmptyListOf nonEmptyStr;
      example = [
        "llama3.1"
        "llama3.2:1b"
      ];
      description = "The models to be automatically downloaded.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.ollama = {
        enable = true;
        openFirewall = true;
        inherit (cfg) acceleration;
        loadModels = cfg.models;
      };
    })

    (lib.mkIf config.system.impermanence.enable {
      environment.persistence."/persist".directories = lib.optional cfg.enable "/var/lib/private/ollama";
    })
  ];
}

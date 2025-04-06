{ config, lib, ... }:
let
  cfg = config.services.ai.ollama;
in
{
  options.services.ai.ollama = {
    enable = lib.mkEnableOption "Ollama";

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

  config.services.ollama = {
    inherit (cfg) enable;
    loadModels = cfg.models;
  };
}

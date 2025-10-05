{ customLib, ... }:
let
  inherit (customLib.ai) genModelTypes;
in
{
  flake.modules.nixos.hosts-aladdin = {
    services.ollama = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      loadModels = [
        "llama3.1:8b"
        "mistral:7b"
        "embeddinggemma:300m"
      ]
      ++ genModelTypes "qwen3" [
        "0.6"
        "1.7"
        4
        8
      ]
      ++ genModelTypes "llama3.2" [
        1
        3
      ]
      ++ genModelTypes "deepseek-r1" [
        "1.5"
        7
        8
      ]
      ++ genModelTypes "gemma3" [
        "270m"
        1
        4
      ];
    };
  };
}

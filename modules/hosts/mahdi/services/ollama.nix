{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    let
      inherit (config.lib.ai) genModelTypes;
    in
    {
      services.ollama = {
        enable = true;
        syncModels = true;
        loadModels = [
          "embeddinggemma:300m"
          "glm-ocr:q8_0"
          "glm-ocr:bf16"
          "gpt-oss:20b"
          "llama3.1:8b"
          "llama3.2-vision:11b"
          "mistral:7b"
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
        ]
        ++ genModelTypes "llama3.2" [
          1
          3
        ]
        ++ genModelTypes "ministral-3" [
          3
          8
        ]
        ++ genModelTypes "qwen3" [
          "0.6"
          "1.7"
          4
          8
        ]
        ++ genModelTypes "qwen3-embedding" [
          "0.6"
          4
        ]
        ++ genModelTypes "translategemma" [
          4
          12
        ];
      };
    };
}

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
          "llama3.1:8b"
          "mistral:7b"
          "gpt-oss:20b"
          "llama3.2-vision:11b"
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

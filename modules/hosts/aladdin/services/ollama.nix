{
  flake.modules.nixos.hosts-aladdin =
    { config, lib, ... }:
    let
      inherit (config.lib.ai) genModelTypes;
    in
    {
      allowedUnfreePackages = lib.optionals config.services.ollama.enable [
        "libcublas"
        "libcurand"
        "libcusparse"
        "libnvjitlink"
        "libcufft"
        "cudnn"
        "cuda_nvrtc"
      ];

      services.ollama = {
        enable = true;
        syncModels = true;
        host = "0.0.0.0";
        openFirewall = true;
        loadModels = [
          "embeddinggemma:300m"
          "glm-ocr:q8_0"
          "glm-ocr:bf16"
          "lfm2.5-thinking:1.2b"
          "llama3.1:8b"
          "mistral:7b"
          "x/flux2-klein:4b"
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

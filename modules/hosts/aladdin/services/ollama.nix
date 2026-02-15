{
  flake.aspects.hosts-aladdin.nixos =
    { config, ... }:
    let
      inherit (config.lib.ai) genModelTypes;
    in
    {
      allowedUnfreePackages = [
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

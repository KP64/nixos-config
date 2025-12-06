{
  flake.modules.nixos.nvidia = {
    allowedUnfreePackages = [
      "cuda_cudart"
      "cuda_nvcc"
      "cuda_cccl"
      "nvidia-x11"
      "nvidia-settings"
    ];

    nixpkgs.config.cudaSupport = true;
    nix.settings = {
      substituters = [ "https://cache.nixos-cuda.org" ];
      trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      nvidia = {
        open = true;
        nvidiaPersistenced = true;
        powerManagement.enable = true;
        prime.allowExternalGpu = true;
      };
      nvidia-container-toolkit.enable = true;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}

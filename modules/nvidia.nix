{ den, ... }:
let
  nixpkgs.config.cudaSupport = true;

  nix.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };
in
{
  den.aspects.nvidia = {
    includes = [
      den.aspects.nvidia._.cache

      (den.batteries.unfree [
        "nvidia-x11"
        "nvidia-settings"

        "cuda_cccl"
        "cuda_cudart"
        "cuda_nvcc"
      ])
    ];

    _.cache = {
      nixos = { inherit nix; };
      homeManager =
        {
          lib,
          osConfig ? null,
          ...
        }:
        lib.mkIf (osConfig == null) { inherit nix; };
    };

    homeManager =
      {
        lib,
        osConfig ? null,
        ...
      }:
      lib.mkIf (osConfig == null) { inherit nixpkgs; };

    nixos = {
      inherit nixpkgs;

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
  };
}

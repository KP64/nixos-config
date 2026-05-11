toplevel@{ den, ... }:
let
  inherit (toplevel.config.flake) modules;

  nixpkgs.config.cudaSupport = true;

  nix.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };

  sharedUnfreePackages = [
    "cuda_cccl"
    "cuda_cudart"
    "cuda_nvcc"
  ];
in
{
  # TODO: Aspect to make integration easier
  den.schema.host.includes = [
    (den.batteries.unfree (
      sharedUnfreePackages
      ++ [
        "nvidia-x11"
        "nvidia-settings"
        # TODO: Revert
        "nvidia-kernel-modules"
      ]
    ))
  ];
  flake.modules = {
    nixos = {
      nvidia-cache = {
        inherit nix;
        home-manager.sharedModules = [ modules.homeManager.nvidia-cache ];
      };

      nvidia = {
        inherit nixpkgs nix;

        home-manager.sharedModules = [ modules.homeManager.nvidia ];

        services.xserver.videoDrivers = [ "nvidia" ];

        hardware = {
          nvidia = {
            # TODO: Revert
            # open = true;
            open = false;
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

    homeManager = {
      nvidia-cache = { inherit nix; };

      nvidia = { inherit nixpkgs nix; };
    };
  };
}

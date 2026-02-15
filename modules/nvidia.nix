toplevel:
let
  nixpkgs.config.cudaSupport = true;

  # TODO: Put this in a separate nvidia module that is only loaded by servers.
  #       Useful for servers that check the flake and have to build the configs of other hosts.
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
  flake.aspects.nvidia = {
    nixos = {
      allowedUnfreePackages = sharedUnfreePackages ++ [
        "nvidia-x11"
        "nvidia-settings"
      ];

      inherit nixpkgs nix;

      home-manager.sharedModules = [ toplevel.config.flake.modules.homeManager.nvidia ];

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
    homeManager = {
      allowedUnfreePackages = sharedUnfreePackages;

      inherit nixpkgs nix;
    };
  };
}

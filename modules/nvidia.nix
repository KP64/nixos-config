{
  flake.modules.nixos.nvidia = {
    nixpkgs.config.cudaSupport = true;

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

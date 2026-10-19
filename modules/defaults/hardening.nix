{
  den.default.nixos = { lib, pkgs, ... }: {
    # NOTE: less prioritized than mkDefault (1000) but more than mkOptionDefault (1500)
    boot.kernelPackages = lib.mkOverride 1400 pkgs.linuxPackages_latest;

    hardware.bluetooth = {
      powerOnBoot = false;
      settings.General = {
        FastConnectable = true;
        Privacy = "network/on";
      };
    };

    security = {
      sudo-rs = {
        enable = true;
        execWheelOnly = true;
      };
      lockKernelModules = true;
      protectKernelImage = true;
      forcePageTableIsolation = true;
      virtualisation.flushL1DataCache = "always";
    };

    # TODO: Enable when Sops-Nix works with that.
    # system = {
    #   etc.overlay = {
    #     enable = true;
    #     mutable = false;
    #   };
    #   nixos-init.enable = true;
    # };
  };
}

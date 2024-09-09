{
  lib,
  pkgs,
  inputs,
  modulesPath,
  ...
}:

{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  nixpkgs.overlays = [
    (_: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
    supportedFilesystems = lib.mkForce [
      "vfat"
      "btrfs"
      "tmpfs"
    ];
  };

  sdImage.compressImage = false;

  networking.hostName = "nixos-pi";

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  users.users.nix-pi = {
    isNormalUser = true;
    initialPassword = ""; # TODO: Add Password to be able to log in.
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      # TODO: Add Public SSH Key
    ];
  };

  system.stateVersion = "24.05";
  nixpkgs.hostPlatform = "aarch64-linux";
}

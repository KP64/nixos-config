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

  nixpkgs = {
    hostPlatform = "aarch64-linux";
    overlays = [
      (_: super: {
        makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
      })
    ];
    config.allowUnfree = true;
  };

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
    supportedFilesystems = lib.mkForce [
      "vfat"
      "btrfs"
      "tmpfs"
    ];
  };

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  sdImage.compressImage = false;

  networking.hostName = "nixos-pi";

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  users.users.nix-pi = {
    isNormalUser = true;
    initialPassword = "";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ ];
  };

  system.stateVersion = "24.11";
}

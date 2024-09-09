{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-pi";

  system.stateVersion = "24.11";

  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };
  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  cli = {
    enable = false;

    git = {
      enable = true;
      user = {
        name = "KP64";
        email = "karamalsadeh@hotmail.com";
      };
    };

    shells = {
      bash.enable = true;
      nushell.enable = false;
    };

    file-managers = {
      yazi.enable = true;
      broot.enable = false;
    };

    ricing = {
      enable = false;
      cava.enable = false;
      fetchers.enable = false;
    };

    terminals.kitty.enable = false;

    monitors = {
      btop.enable = false;
      bandwhich.enable = false;
    };
  };

  editors.helix.enable = true;

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

  console.keyMap = "de";
  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Define a user account.
  # Don't forget to replace the hashedPassword below with your own.
  # To get the hashedPasword run:
  # $ mkpasswd -m sha-512 {your_password}
  users = {
    mutableUsers = false;
    users.${username} = {
      isNormalUser = true;
      description = username;
      initialPassword = "12345";
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "libvirtd"
        "tss"
      ];
      openssh.authorizedKeys.keys = [
        # TODO: Add Public SSH Key
      ];
    };
  };
}

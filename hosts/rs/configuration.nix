{
  lib,
  username,
  stateVersion,
  ...
}:
{
  system = {
    inherit stateVersion;
    security = {
      uutils-coreutils.enable = true;
      polkit.enable = true;
      sudo-rs.enable = true;
    };
  };

  home-manager.users.${username}.gtk.catppuccin.icon.enable = lib.mkForce false;

  cli = {
    defaults.enable = true;

    git = {
      enable = true;
      user = {
        name = "KP64";
        email = "karamalsadeh@hotmail.com";
      };
    };

    shells = {
      bash.enable = true;
      nushell.enable = true;
    };

    file-managers.yazi.enable = true;

    monitors = {
      btop.enable = true;
      bandwhich.enable = true;
    };
  };

  sdImage = {
    imageName = "kernel.img";
    compressImage = false;
  };

  # bcm2711 for rpi 3, 3+, 4, zero 2 w
  # bcm2712 for rpi 5
  # See the docs at:
  # https://www.raspberrypi.com/documentation/computers/linux_kernel.html#native-build-configuration
  raspberry-pi-nix.board = "bcm2711";

  networking = {
    hostName = username;
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = true;
      eth0.useDHCP = true;
    };
  };

  hardware = {
    bluetoothctl.enable = true;
    raspberry-pi = {
      config = {
        all = {
          base-dt-params = {
            # enable autoprobing of bluetooth driver
            # https://github.com/raspberrypi/linux/blob/c8c99191e1419062ac8b668956d19e788865912a/arch/arm/boot/dts/overlays/README#L222-L224
            krnbt = {
              enable = true;
              value = "on";
            };
          };
        };
      };
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

  users = {
    mutableUsers = false;
    users = {
      root.initialPassword = "root";
      ${username} = {
        isNormalUser = true;
        description = username;
        initialPassword = "12345";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAprQ6/cB+MxEK5IorzJ1+/HoYqyc5ZItGG4HzYwTO3S karamalsadeh@hotmail.com"
        ];
        extraGroups = [
          "networkmanager"
          "wheel"
          "input"
          "docker"
          "libvirtd"
          "tss"
        ];
      };
    };
  };
}

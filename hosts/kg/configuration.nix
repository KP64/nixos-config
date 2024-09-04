{
  username,
  stateVersion,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  system = {
    inherit stateVersion;
    boot.efi.enable = true;
    security = {
      uutils-coreutils.enable = true;
      polkit.enable = true;
      tpm.enable = true;
      secure-boot.enable = true;
      sudo-rs.enable = true;
    };
  };

  cli.git = {
    enable = true;
    user = {
      name = "KP64";
      email = "karamalsadeh@hotmail.com";
    };
  };

  hardware = {
    audio.enable = true;
    bluetoothctl.enable = true;
    networking.enable = true;
    nvidia.enable = true;
  };

  desktop = {
    enable = true;

    eww.enable = true;
    waybar.enable = true;

    rofi.enable = true;

    login.sddm.enable = true;

    hypr = {
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      hyprpicker.enable = true;
      contrib.grimblast.enable = true;
      hyprland = {
        enable = true;
        monitors = [
          {
            name = "DP-3";
            resolution = "highrr";
            vrr = 2;
          }
          {
            name = "HDMI-A-1";
            x = 1920;
            y = 500;
          }
        ];
        workspaces = [
          {
            id = 1;
            monitorName = "DP-3";
            default = true;
          }
          {
            id = 2;
            monitorName = "HDMI-A-1";
            default = true;
          }
        ];
      };
    };

    services = {
      blueman-app.enable = true;
      copyq.enable = true;
      mako.enable = true;
      ntwrk-mgr-app.enable = true;
      udiskie.enable = true;
    };
  };

  editors = {
    aseprite.enable = true;
    helix.enable = true;
    vscode.enable = true;
  };

  apps = {
    enable = true;
    spicetify.enable = true;
    obs.enable = true;
    mpv.enable = true;
    thunderbird.enable = true;
    browsers = {
      firefox.enable = true;
      tor.enable = true;
    };
  };

  virt.docker.enable = true;

  gaming = {
    enable = true;
    heroic.enable = true;
    mangohud.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };

  networking.hostName = username;

  services.xserver.xkb = {
    layout = "de";
    variant = "";
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

  console.keyMap = "de";
  nixpkgs.config.allowUnfree = true;

  # Define a user account.
  # Don't forget to replace the hashedPassword below with your own.
  # To get the hashedPasword run:
  # $ mkpasswd -m sha-512 {your_password}
  users = {
    mutableUsers = false;
    users.${username} = {
      isNormalUser = true;
      description = username;
      hashedPassword = "$6$iLbwJ.7EhqTOe/Zf$ZOD4llDEoR/HaYM34Mf/ZMmLyTDw6CPwRi4jOlK3Z5b1aza9W9jls0crvTJG5rTo85luxzD9xywHslxeqITG30";
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "docker"
        "kvm"
        "libvirtd"
        "audio"
        "video"
        "tss"
      ];
    };
  };
}

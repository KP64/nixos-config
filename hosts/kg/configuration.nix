# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  username,
  stateVersion,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  system = {
    boot.efi.enable = true;
    fonts.enable = true;
    nix.enable = true;
    security = {
      polkit.enable = true;
      tpm.enable = true;
    };
    autoupgrade.enable = true;
  };

  hardware = {
    audio.enable = true;
    bluetoothctl.enable = true;
    networking.enable = true;
    nvidia.enable = true;
  };

  apps = {
    enable = true;
    spicetify.enable = true;
    obs.enable = true;
    mpv.enable = true;
    thunderbird.enable = true;
    firefox.enable = true;
  };

  editors = {
    helix.enable = true;
    vscode.enable = true;
  };

  gaming = {
    enable = true;
    heroic.enable = true;
    mangohud.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };

  desktop = {
    enable = true;
    catppuccin.enable = true;
    eww.enable = true;
    rofi.enable = true;
    waybar.enable = true;
    hypr = {
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprland.enable = true;
      hyprpaper.enable = true;
    };
    services = {
      blueman-app.enable = true;
      copyq.enable = true;
      mako.enable = true;
      ntwrk-mgr-app.enable = true;
      udiskie.enable = true;
    };
  };

  networking.hostName = username;

  services = {
    xserver.xkb = {
      layout = "de";
      variant = "";
    };
    # TODO: Refactor to "Desktop Login Module"
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd hyprland";
        user = "kg";
      };
    };
    # FIXME: Only logins to Steam instead of Hyprland
    # displayManager.sddm = {
    #   enable = true;
    #   wayland.enable = true;
    #   catppuccin.background = builtins.toString ../../wallpapers/nixos-wallpaper-catppuccin-mocha.png;
    #   package = pkgs.kdePackages.sddm;
    # };
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

  # Configure console keymap
  console.keyMap = "de";
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = false;
    users.kg = {
      isNormalUser = true;
      description = "kg";
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

  virtualisation = {
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
    libvirtd.enable = true;
  };

  system.stateVersion = stateVersion; # Did you read the comment?
}

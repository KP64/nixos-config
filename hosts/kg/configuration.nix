# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  catppuccin.enable = true;

  nix = {
    channel.enable = true; # rust-analyzer in vscode depends on it
    optimise.automatic = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "kg"
      ];
      auto-optimise-store = true;
      substituters = [
        "https://hyprland.cachix.org"
        "https://yazi.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      ];
    };
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    flake = "github:KP64/nixos-config";
  };

  environment = {
    pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      DIRENV_LOG_FORMAT = "";
    };
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };

    nvidia = {
      powerManagement.enable = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
    nvidia-container-toolkit.enable = true;

    bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    opentabletdriver.enable = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "v4l2loopback" ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };

  networking.hostName = "kg"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  services = {
    blueman.enable = true;
    udisks2.enable = true;
    xserver = {
      xkb = {
        layout = "de";
        variant = "";
      };
      videoDrivers = [ "nvidia" ];
      digimend.enable = true;
    };
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

  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
        "Noto"
        "NerdFontsSymbolsOnly"
      ];
    })
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    cachix
    nixfmt-rfc-style
    devenv
    fh
    statix
    nurl
    deadnix
    nil
    nvd
    nixpkgs-lint-community
    nix-melt
    nix-output-monitor
    nix-health
    nix-tree
  ];

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
    # TODO: Change values to prevent underruns in games
    extraConfig.pipewire."92-low-latency".context.properties.default.clock = {
      rate = 48000;
      quantum = 256; # default: 32
      min-quantum = 128; # default: 32
      max-quantum = 512; # default: 32
    };
  };

  programs = {
    dconf.enable = true;
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
      flake = "/home/kg/Desktop/nixos-config";
    };
    bandwhich.enable = true;
    gamemode.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
    nix-ld = {
      enable = true;
      package = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}

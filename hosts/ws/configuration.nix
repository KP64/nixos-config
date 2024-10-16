{
  config,
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

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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
    file-managers = {
      yazi.enable = true;
      broot.enable = true;
    };
    ricing = {
      defaults.enable = true;
      cava.enable = true;
      fetchers.enable = true;
    };
    monitors = {
      btop.enable = true;
      bandwhich.enable = true;
    };
  };

  editors.helix.enable = true;

  networking.hostName = username;

  services.xserver.xkb = {
    layout = "en";
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

  console.keyMap = "en";
  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets.hashed_password.neededForUsers = true;
  };

  users.users.${username} = {
    hashedPasswordFile = config.sops.secrets.hashed_password.path;
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
}

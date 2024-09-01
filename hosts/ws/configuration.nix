{ username, stateVersion, ... }:

{
  system = {
    inherit stateVersion;
    security = {
      uutils-coreutils.enable = true;
      polkit.enable = true;
      sudo-rs.enable = true;
    };
  };
  programs.cli.git = {
    enable = true;
    user = {
      name = "KP64";
      email = "karamalsadeh@hotmail.com";
    };
  };

  home-manager.users.${username}.programs.bash.initExtra = "nu";

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

  # Define a user account.
  # Don't forget to replace the hashedPassword below with your own.
  # To get the hashedPasword run:
  # $ mkpasswd -m sha-512 {your_password}
  users = {
    mutableUsers = false;
    users.${username} = {
      isNormalUser = true;
      description = username;
      hashedPassword = "$6$3CmmZdMdGfo6GcA9$wlFmrSL5KW9TI6sVUunn.CpFz5OJJNQSlYNgh83lPcSyni7LiaSljW5lnX6Lprj/MP4QN9KFhHEN/Blea00P7.";
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

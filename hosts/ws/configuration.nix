{
  config,
  username,
  invisible,
  stateVersion,
  ...
}:

{
  system = {
    inherit stateVersion;
    language = "en";
    security = {
      uutils-coreutils.enable = true;
      polkit.enable = true;
      sudo-rs.enable = true;
    };
    style.catppuccin = {
      enable = true;
      enableGtkIcons = false;
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  file-managers.enable = true;

  cli = {
    enable = true;

    git.user = {
      name = "KP64";
      inherit (invisible) email;
    };

    ricing.cava.enable = false;
  };

  editors.helix.enable = true;

  topology.self.hardware.info = "WSL";

  networking.hostName = username;

  time.timeZone = "Europe/Berlin";

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
      "kvm"
      "libvirtd"
      "audio"
      "video"
      "tss"
    ];
  };
}

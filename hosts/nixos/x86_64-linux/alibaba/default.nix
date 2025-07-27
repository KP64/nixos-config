{
  wsl = {
    enable = true;
    defaultUser = "ws";
    useWindowsDriver = true;
    interop.register = true;
    startMenuLaunchers = true;
    usbip.enable = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nixpkgs.config.allowUnfree = true;

  security.polkit.enable = true;

  system = {
    stateVersion = "25.11";
    language = "en";
    security.sudo-rs.enable = true;
    ssh.enable = true;
    style.catppuccin.enable = true;
  };

  time.timeZone = "Europe/Berlin";

  topology.self.hardware.info = "WSL";
}

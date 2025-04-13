{
  system = {
    stateVersion = "24.05";
    sshd = {
      enable = true;
      pathToPubKey = ./sshKey.pub;
    };
  };

  time.timeZone = "Europe/Berlin";

  # terminal.font = ""; # TODO

  android-integration = {
    am.enable = true;

    termux-open.enable = true;
    termux-open-url.enable = true;

    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
    xdg-open.enable = true;
  };
}

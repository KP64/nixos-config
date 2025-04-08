{ pkgs, ... }:
{
  system.stateVersion = "24.05";

  time.timeZone = "Europe/Berlin";

  # terminal.font = ""; # TODO:

  android-integration = {
    am.enable = true;

    # TODO: whats the diff?
    termux-open.enable = true;
    termux-open-url.enable = true;

    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
    # unsupported.enable = true; # TODO: How bad can it be? ;)
    xdg-open.enable = true;
  };
}

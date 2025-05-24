{ pkgs, ... }:
{
  system = {
    stateVersion = "25.11";
    sshd = {
      enable = true;
      pathToPubKey = ./sshKey.pub;
    };
  };

  time.timeZone = "Europe/Berlin";

  terminal.font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontMono-Regular.ttf";

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

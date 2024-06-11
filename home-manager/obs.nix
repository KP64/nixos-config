{ pkgs, inputs, ... }:
{
  xdg.configFile."obs-studio/themes" = {
    source = inputs.obs-catppuccin + "/themes/";
    recursive = true;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vaapi
      obs-vkcapture
      obs-pipewire-audio-capture
    ];
  };
}

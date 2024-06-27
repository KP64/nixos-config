{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [ heroic ];

  xdg.configFile."heroic/themes" = {
    source = inputs.heroic-catppuccin + "/themes/";
    recursive = true;
  };
}

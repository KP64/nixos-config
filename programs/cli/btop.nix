{ pkgs, username, ... }:
{
  home-manager.users.${username}.programs.btop = {
    enable = true;
    # Allows GPU detection for Nvidia cards
    package = pkgs.btop.override { cudaSupport = true; };
    # gpu0 not shown by default
    settings.shown_boxes = "cpu mem net proc gpu0";
  };
}

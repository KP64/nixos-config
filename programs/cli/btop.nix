{ pkgs, username, ... }:
{
  home-manager.users.${username}.programs.btop = {
    enable = true;
    package = pkgs.btop.override { cudaSupport = true; };
  };
}

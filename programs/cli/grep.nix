{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      bingrep
      igrep
      sig
    ];
    programs.ripgrep.enable = true;
  };
}

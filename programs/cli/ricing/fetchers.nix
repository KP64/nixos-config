{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      onefetch
      cpufetch
      # gpufetch # Not available on nixpkgs
    ];

    programs.fastfetch.enable = true;
  };
}

{ pkgs, username, ... }:
{
  imports = [
    ./cava.nix
    ./fetchers.nix
  ];

  home-manager.users.${username}.home.packages = with pkgs; [
    cbonsai
    pipes-rs
  ];
}

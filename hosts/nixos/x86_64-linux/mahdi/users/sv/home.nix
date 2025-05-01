{ config, invisible, ... }:
let
  inherit (config.home) username;
in
{
  home.stateVersion = "24.11";

  system.style.catppuccin.enable = true;

  programs = {
    bat.enable = true;
    btop.enable = true;
    fzf.enable = true;
    pay-respects.enable = true;
    ripgrep.enable = true;
  };

  cli = {
    atuin.enable = true;
    fd.enable = true;
    fetchers.enable = true;
    git = {
      enable = true;
      user = {
        name = "KP64";
        inherit (invisible.users.${username}) email;
      };
    };
    lsd.enable = true;
    multiplexer.zellij.enable = true;
    starship.enable = true;
    shells = {
      bash.enable = true;
      nushell.enable = true;
    };
    zoxide.enable = true;
  };

  editors = {
    helix.enable = true;
    neovim.enable = true;
  };

  file-managers.yazi.enable = true;
}

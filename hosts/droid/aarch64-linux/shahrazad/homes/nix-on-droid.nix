{ invisible, ... }:
{
  home.stateVersion = "24.11";

  system.style.catppuccin = {
    enable = true;
    enableGtkIcons = false;
  };

  programs = {
    bacon.enable = true;
    bat.enable = true;
    btop.enable = true;
    cava.enable = true;
    fzf.enable = true;
    pay-respects.enable = true;
    ripgrep.enable = true;
    zellij.enable = true;
  };

  cli = {
    atuin.enable = true;
    fd.enable = true;
    fetchers.enable = true;
    git = {
      enable = true;
      user = {
        name = "KP64";
        inherit (invisible) email;
      };
    };
    lsd.enable = true;
    navi.enable = true;
    ricing.enable = true;
    starship.enable = true;
    shells = {
      bash.enable = true;
      nushell.enable = true;
    };
    tealdeer.enable = true;
    zoxide.enable = true;
  };

  editors = {
    helix.enable = true;
    neovim.enable = true;
  };

  file-managers = {
    broot.enable = true;
    yazi.enable = true;
  };
}

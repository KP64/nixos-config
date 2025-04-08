{ invisible, ... }:
{
  home.stateVersion = "24.11";

  system.style.catppuccin.enable = true;

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    udiskie.enable = true;
    podman = {
      enable = true;
      enableTypeChecks = true;
    };
  };

  programs = {
    bacon.enable = true;
    bat.enable = true;
    btop.enable = true;
    cava.enable = true;
    fzf.enable = true;
    mpv.enable = true;
    mangohud.enable = true;
    pay-respects.enable = true;
    ripgrep.enable = true;
    zellij.enable = true;
  };

  apps = {
    spicetify.enable = true;
    thunderbird.enable = true;
    obs.enable = true;
  };

  browsers.firefox.enable = true;

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

  desktop = {
    services.copyq.enable = true;

    rofi.enable = true;
    hypridle.enable = true;
    hyprlock.enable = true;
    hyprpanel.enable = true;
    hyprpaper.enable = true;
    hyprland = {
      enable = true;
      monitors = [
        {
          name = "DP-3";
          resolution = "highrr";
          vrr = 2;
          workspaces = [
            {
              id = 1;
              default = true;
            }
          ];
        }
        {
          name = "HDMI-A-1";
          x = 1920;
          y = 500;
          workspaces = [
            {
              id = 2;
              default = true;
            }
          ];
        }
      ];
    };
  };

  editors = {
    blender.enable = true;
    helix.enable = true;
    imhex.enable = true;
    neovim.enable = true;
    vscode.enable = true;
    zed.enable = true;
  };

  file-managers = {
    broot.enable = true;
    yazi.enable = true;
  };

  gaming = {
    discord.enable = true;
    emulators = {
      nintendo.enable = true;
      playstation.enable = true;
      xbox.enable = true;
    };
    launchers.heroic.enable = true;
  };

  terminals.kitty.enable = true;
}

{
  config,
  pkgs,
  invisible,
  ...
}:
{
  home = {
    stateVersion = "24.11";
    packages = with pkgs; [
      openboard
      ventoy
    ];
  };

  system.style.catppuccin.enable = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age =
      let
        inherit (config.home) homeDirectory;
      in
      {
        keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
        sshKeyPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];
      };
    secrets = {
      "atuin/key" = { };
      "atuin/session" = { };
      "weather.json" = { };
    };
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    udiskie.enable = true;
  };

  programs = {
    bacon.enable = true;
    bat.enable = true;
    btop.enable = true;
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
    # zoxide.enable = true;
  };

  desktop = {
    services.copyq.enable = true;

    rofi.enable = true;
    hypridle.enable = true;
    hyprlock.enable = true;
    hyprpanel.enable = true;
    hyprpaper.enable = true;
    hyprsunset.enable = true;
    hyprland = {
      enable = true;
      monitors = [
        {
          name = "eDP-1";
          resolution = "highrr";
          vrr = 2;
        }
      ];
    };
  };

  editors = {
    helix.enable = true;
    neovim.enable = true;
    vscode.enable = true;
  };

  file-managers = {
    broot.enable = true;
    yazi.enable = true;
  };

  gaming.discord.enable = true;

  terminals.kitty.enable = true;
}

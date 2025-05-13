{
  config,
  pkgs,
  invisible,
  rootPath,
  ...
}:
let
  inherit (config.home) homeDirectory username;
in
{
  home = {
    stateVersion = "24.11";
    packages = with pkgs; [
      igrep
      oh-my-git
      simplex-chat-desktop
      prismlauncher
      hyperfine
      anki
    ];
  };

  system.style.catppuccin.enable = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
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
    podman = {
      enable = true;
      enableTypeChecks = true;
    };
  };

  programs = {
    bacon.enable = true;
    bat.enable = true;
    btop.enable = true;
    fzf.enable = true;
    mpv.enable = true;
    mangohud.enable = true;
    nh.flake = "${homeDirectory}/Desktop/nixos-config";
    pay-respects.enable = true;
    ripgrep.enable = true;
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
        inherit (invisible.users.${username}) email;
      };
    };
    lsd.enable = true;
    multiplexer.zellij.enable = true;
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
    hyprpaper = {
      enable = true;
      wallpaper = "${rootPath}/assets/wallpapers/catppuccin/retro2_live.png";
    };
    hyprsunset.enable = true;
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
    emulators.nintendo.enable = true;
    launchers.heroic.enable = true;
  };

  terminals = {
    ghostty.enable = true;
    kitty.enable = true;
  };
}

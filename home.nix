{
  # config, 
  pkgs,
  inputs,
  ...
}:

{
  nix.gc.automatic = true;

  home = {
    stateVersion = "24.05";
    username = "kg";
    homeDirectory = "/home/kg";
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    file = {
      ".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
      ".config/hypr/hypridle.conf".source = ./hypridle.conf;
    };

    packages =
      (with inputs; [
        hyprpicker.packages.${pkgs.system}.hyprpicker
        hypridle.packages.${pkgs.system}.hypridle
        hyprlock.packages.${pkgs.system}.hyprlock
      ])
      ++ (with pkgs; [
        asciinema
        ani-cli
        tokei
        sshx
        just
        lychee
        gping
        hexyl

        discord
        whatsapp-for-linux
        protonup

        onefetch
        hyperfine
        hurl
        gitoxide

        dust
        procs
        sd
        xcp
        jnv
        glow
        kondo

        swww
        rofi-wayland
      ]);
  };
  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  services = {
    copyq.enable = true;
    udiskie.enable = true;
    dunst.enable = true;
    network-manager-applet.enable = true;
    blueman-applet.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  programs = {
    home-manager.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
      ];
    };

    mangohud.enable = true;

    waybar = {
      enable = true;
      systemd.enable = true;
    };

    bottom.enable = true;

    btop.enable = true;

    thefuck.enable = true;

    fzf.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    tealdeer.enable = true;

    nushell = {
      enable = true;
      configFile.text = ''
        $env.config = {
          show_banner: false
        }
      '';
      extraEnv = ''
        def --env fcd [dir = "."] {
          let selected_dir = (fd . $dir -t d | fzf --reverse)
          if $selected_dir == "" {
            return null;
          }
          cd $selected_dir
          $selected_dir
        }

        def --env fhx [dir = "."] {
          let selected_dir = fcd $dir
          if $selected_dir == null {
            return;
          }
          let selected_file = (fd . $dir -t f | fzf --reverse)
          if $selected_file == "" {
            cd -
          } else {
            hx $selected_file
          }
        }
      '';
    };

    zellij = {
      enable = true;
      settings = { };
    };

    bat.enable = true;

    lsd = {
      enable = true;
      enableAliases = true;
    };

    navi.enable = true;

    ripgrep.enable = true;

    fd.enable = true;

    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };

    xplr.enable = true;

    gitui.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
      userName = "KP64";
      userEmail = "karamalsadeh@hotmail.com";
      delta = {
        enable = true;
        options = {
          line-numbers = true;
        };
      };
      extraConfig = {
        init.defaultBranch = "master";
        safe.directory = "/etc/nixos";
      };
    };

    atuin = {
      enable = true;
      settings = {
        invert = true;
        filter_mode_shell_up_key_binding = "directory";
      };
    };

    bash.enable = true;

    kitty = {
      enable = true;
      font.name = "JetBrainsMono Nerd Font";
      settings = {
        shell = "nu";
        background_opacity = "0.8";
      };
    };

    starship.enable = true;

    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
        };
      };
    };

    firefox = {
      enable = true;
      profiles.kg = {
        settings = {
          "dom.security.https_only_mode" = true;
        };

        extensions = with inputs.firefox-addons.packages."${pkgs.system}"; [
          ublock-origin
          darkreader
          simple-translate
          # enhancer-for-youtube # FIXME: Needs unfree even though enabled
          facebook-container
          multi-account-containers
          return-youtube-dislikes
          privacy-badger
          greasemonkey
          i-dont-care-about-cookies
          # languagetool # See above
          private-relay
          videospeed
        ];
      };
    };
  };
}

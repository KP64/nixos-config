{ 
  pkgs,
  inputs,
  ...
}:

{
  nix.gc.automatic = true;

  imports = [
    ./hypr/hyprland.nix
    ./hypr/hypridle.nix
    ./hypr/hyprlock.nix
    ./editors/helix.nix
    ./editors/vscodium.nix
    ./spicetify.nix
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      inputs.xdg-desktop-portal-hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [
      "hyprland"
      "gtk"
    ];
  };

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

    packages =
      with inputs;
      [ hyprpicker.packages.${pkgs.system}.hyprpicker ]
      ++ (with pkgs; [
        asciinema
        ani-cli
        tokei
        sshx
        just
        lychee
        gping
        hexyl

        neofetch
        cpufetch
        # gpufetch # Not available on nixpkgs yet

        discord
        spicetify-cli
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

  programs = {
    home-manager.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
      ];
    };

    yazi = {
      enable = true;
      settings.manager.show_hidden = true;
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

    tealdeer = {
      enable = true;
      settings = {
        updates.auto_update = true;
        display.use_pager = true;
      };
    };

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

                def --env yy [...args] {
        	        let tmp = (mktemp -t "yazi-cwd.XXXXXX")
        	        yazi ...$args --cwd-file $tmp
        	        let cwd = (open $tmp)
        	        if $cwd != "" and $cwd != $env.PWD {
        		        cd $cwd
        	        }
        	        rm -fp $tmp
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

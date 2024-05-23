{ pkgs, inputs, ... }:

let
  catppuccin = {
    enable = true;
    flavour = "mocha";
  };
in

{
  nix.gc.automatic = true;

  imports = [
    (import ./hypr/hyprland.nix catppuccin)
    ./hypr/hyprpaper.nix
    ./hypr/hypridle.nix
    ./hypr/hyprlock.nix
    (import ./editors/helix.nix catppuccin)
    ./editors/vscode.nix
    ./spicetify.nix
    ./obs.nix
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.nix-index-database.hmModules.nix-index
  ];
  xdg.configFile = {
    "eww/eww.yuck".source = ./eww.yuck;
    "eww/eww.scss".source = ./eww.scss;
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        inputs.xdg-desktop-portal-hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common.default = [ "gtk" ];
        hyprland.default = [
          "gtk"
          "hyprland"
        ];
      };
    };
  };

  home = {
    stateVersion = "24.05";
    username = "kg";
    homeDirectory = "/home/kg";
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "Catppuccin-Mocha-Dark-Cursors";
      size = 24; # catppuccin cursor sizes: 24, 32, 48, 64
    };
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~/.steam/root/compatibilitytools.d";
    };

    packages =
      with inputs;
      [
        hyprpicker.packages.${pkgs.system}.hyprpicker
        hyprland-contrib.packages.${pkgs.system}.grimblast
        # eww.packages.${pkgs.system}.eww
        nix-alien.packages.${pkgs.system}.nix-alien
      ]
      ++ (with pkgs; [
        asciinema
        ani-cli
        tokei
        sshx
        just
        lychee
        gping
        hexyl

        libnotify

        fastfetch
        cpufetch
        # gpufetch # Not available on nixpkgs yet

        discord
        webcord
        spicetify-cli
        whatsapp-for-linux

        wineWowPackages.waylandFull
        protonup
        heroic

        dolphin-emu
        ryujinx
        xemu

        aseprite
        mpv

        unzip
        wl-clipboard
        grim
        slurp

        onefetch
        hyperfine
        hurl
        gitoxide
        igrep

        dust
        procs
        sd
        xcp
        jnv
        glow
        kondo

        atlauncher
        steam-run
        pavucontrol
      ]);
  };

  gtk = {
    enable = true;
    inherit catppuccin;
  };

  services = {
    copyq.enable = true;
    udiskie.enable = true;
    pueue.enable = true;
    mako = {
      enable = true;
      inherit catppuccin;
      defaultTimeout = 5000;
    };
    network-manager-applet.enable = true;
    blueman-applet.enable = true;
  };

  programs = {
    home-manager.enable = true;

    nix-index.enable = true;
    nix-index-database.comma.enable = true;

    yazi = {
      enable = true;
      inherit catppuccin;
      settings.manager.show_hidden = true;
    };

    mangohud.enable = true;

    waybar = {
      enable = true;
      inherit catppuccin;
      systemd.enable = true;
    };

    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      inherit catppuccin;
    };

    bottom = {
      enable = true;
      inherit catppuccin;
    };

    btop = {
      enable = true;
      inherit catppuccin;
    };

    cava.enable = true;

    thefuck.enable = true;

    fzf = {
      enable = true;
      inherit catppuccin;
    };

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
      inherit catppuccin;
    };

    bat = {
      enable = true;
      inherit catppuccin;
    };

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

    gitui = {
      enable = true;
      inherit catppuccin;
    };

    git = {
      enable = true;
      lfs.enable = true;
      userName = "KP64";
      userEmail = "karamalsadeh@hotmail.com";
      delta = {
        enable = true;
        inherit catppuccin;
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
      inherit catppuccin;
      font.name = "JetBrainsMono Nerd Font";
      settings = {
        shell = "nu";
        background_opacity = "0.8";
      };
    };

    starship = {
      enable = true;
      inherit catppuccin;
      settings = {
        format = "$all";
      } // builtins.fromTOML (builtins.readFile ./starship_preset.toml);
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
          firefox-color
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

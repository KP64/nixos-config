{ 
  # config, 
  pkgs,
  # inputs, 
  ... 
}:

{
  nix.gc.automatic = true;

  home = {
    stateVersion = "24.05";
    username = "kg";
    homeDirectory = "/home/kg";
    packages = with pkgs; [
      asciinema
      ani-cli
      tokei
      sshx
      just
      lychee
      gping
      hexyl

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
    ];
  };

  services.pueue.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  programs = {
    home-manager.enable = true;

    waybar = {
      enable = false;
      systemd.enable = false;
    };
    
    bottom.enable = true;
    
    thefuck.enable = true;
    
    fzf.enable = true;
    
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    
    tealdeer.enable = true;
    
    nushell = {
      enable = true;
      configFile.text= ''
      $env.config = {
        show_banner: false
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
      userName = "KP64";
      userEmail = "karamalsadeh@hotmail.com";
      delta.enable = true;
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

    bash = {
      enable = true;
      initExtra = "nu";
    };
    
    kitty = {
      enable = true;
      font.name = "JetBrainsMono Nerd Font";
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
    
    firefox.enable = true;
  };
}

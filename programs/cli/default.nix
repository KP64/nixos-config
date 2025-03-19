{
  lib,
  config,
  pkgs,
  stable-pkgs,
  username,
  ...
}:
let
  cfg = config.cli;
in
{
  imports = [
    ./monitors
    ./ricing
    ./shells
    ./starship

    ./atuin.nix
    ./bacon.nix
    ./bat.nix
    ./dconf.nix
    ./fd.nix
    ./fuzzy-finder.nix
    ./git.nix
    ./lsd.nix
    ./navi.nix
    ./grep.nix
    ./tealdeer.nix
    ./thefuck.nix
    ./trippy.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  options.cli = {
    enable = lib.mkEnableOption "CLI";
    misc.enable = lib.mkEnableOption "Misc Cli Apps";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      cli = {
        monitors.enable = lib.mkDefault true;
        ricing.enable = lib.mkDefault true;
        shells.enable = lib.mkDefault true;
        git.enable = lib.mkDefault true;
        misc.enable = lib.mkDefault true;
      };
    })

    {
      home-manager.users.${username} = {
        services.pueue.enable = true;

        home.packages =
          lib.optionals cfg.misc.enable [ stable-pkgs.ani-cli ]
          ++ (with pkgs; [
            # misc
            dipc
            glow
            hexyl
            hyperfine
            kondo
            mkcert
            monolith
            tokei
            wthrr

            # presentation
            asciinema
            eureka-ideas
            presenterm

            # regex
            grex
            melody

            # files
            ouch
            oxipng
            qrtool

            # calc
            kalker
            numbat

            # core-utils++
            choose
            dust
            jnv
            sd
            sshx

            # networking
            bore-cli
            hurl
            xh

            # inspect & monitoring
            binsider
            doggo
            gping
            netscanner
            procs
            rustscan
            systemctl-tui
            systeroid
            binwalk

            # Social account finders
            maigret
            sherlock
          ]);
      };
    }
  ];
}

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

    # TODO: Further categorize
    {
      home-manager.users.${username} = {
        services.pueue.enable = true;
        home.packages =
          lib.optionals cfg.misc.enable [ stable-pkgs.ani-cli ]
          ++ (with pkgs; [
            asciinema
            binsider
            choose
            dipc
            doggo
            dust
            glow
            gping
            grex
            hexyl
            hurl
            hyperfine
            jnv
            just
            kondo
            lychee
            mkcert
            monolith
            ouch
            presenterm
            procs
            rustscan
            sd
            sshx
            systemctl-tui
            tokei
            typst
            xh

            licensor
            qrtool
            melody
            wthrr
            numbat
            systeroid
            netscanner
            kalker
            oxipng
            eureka-ideas

            sherlock
            maigret
          ]);
      };
    }
  ];
}

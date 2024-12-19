{
  lib,
  config,
  pkgs,
  stable-pkgs,
  username,
  ...
}:

{
  imports = [
    ./file-managers
    ./monitors
    ./ricing
    ./shells
    ./starship
    ./terminals

    ./atuin.nix
    ./bacon.nix
    ./bat.nix
    ./dconf.nix
    ./fd.nix
    ./fzf.nix
    ./git.nix
    ./lsd.nix
    ./navi.nix
    ./greps.nix
    ./tealdeer.nix
    ./thefuck.nix
    ./trippy.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  options.cli.defaults.enable = lib.mkEnableOption "Default Cli Apps";

  config = lib.mkIf config.cli.defaults.enable {
    home-manager.users.${username}.home.packages =
      [ stable-pkgs.ani-cli ]
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
        ouch
        procs
        rustscan
        sd
        sshx
        systemctl-tui
        tokei
        typst
        xh

        sherlock
        maigret
      ]);
  };
}

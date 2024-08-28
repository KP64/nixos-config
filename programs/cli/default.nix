{ pkgs, username, ... }:

{
  imports = [
    ./file-managers
    ./ricing
    ./shells
    ./starship

    ./atuin.nix
    ./bacon.nix
    ./bandwhich.nix
    ./bat.nix
    ./btop.nix
    ./dconf.nix
    ./fd.nix
    ./fzf.nix
    ./git.nix
    ./kitty.nix
    ./lsd.nix
    ./navi.nix
    ./greps.nix
    ./tealdeer.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  home-manager.users.${username}.home.packages = with pkgs; [
    asciinema
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
    procs
    rustscan
    sd
    sshx
    tailspin
    tokei
    treefmt2
    typst
    xh

    ani-cli
    sherlock

    ouch
  ];
}

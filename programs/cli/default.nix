{ pkgs, username, ... }:

{
  imports = [
    ./ricing
    ./starship

    ./atuin.nix
    ./bacon.nix
    ./bandwhich.nix
    ./bash.nix
    ./bat.nix
    ./broot.nix
    ./btop.nix
    ./dconf.nix
    ./fd.nix
    ./fzf.nix
    ./git.nix
    ./kitty.nix
    ./lsd.nix
    ./navi.nix
    ./nushell.nix
    ./ripgrep.nix
    ./tealdeer.nix
    ./yazi.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  home-manager.users.${username}.home.packages = with pkgs; [
    asciinema
    dust
    glow
    gping
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
    xh

    ani-cli
    sherlock

    ouch
  ];
}

{ pkgs, username, ... }:

{
  imports = [
    ./starship

    ./atuin.nix
    ./bacon.nix
    ./bandwhich.nix
    ./bash.nix
    ./bat.nix
    ./broot.nix
    ./btop.nix
    ./cava.nix
    ./dconf.nix
    ./fastfetch.nix
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
    cbonsai
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
    pipes-rs
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

    onefetch
    cpufetch
    # gpufetch # Not available on nixpkgs

    ouch
  ];
}

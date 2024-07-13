{
  pkgs,
  inputs,
  username,
  ...
}:

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
    ./thefuck.nix
    ./yazi.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  home-manager.users.${username}.home.packages =
    with inputs;
    [ treefmt.packages.${pkgs.system}.treefmt ]
    ++ (with pkgs; [
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
      sd
      sshx
      tailspin
      tokei

      ani-cli
      sherlock

      onefetch
      cpufetch
      # gpufetch # Not available on nixpkgs

      ouch
    ]);
}

{ inputs, pkgs, ... }:

{
  home.packages =
    with inputs;
    [ nix-alien.packages.${pkgs.system}.nix-alien ]
    ++ (with pkgs; [
      asciinema
      ani-cli
      tokei
      sshx
      just
      lychee
      gping
      hexyl

      onefetch
      cpufetch
      # gpufetch # Not available on nixpkgs yet

      ouch
      wl-clipboard
      grim
      slurp

      exiftool

      hyperfine
      hurl
      gitoxide
      gitleaks
      igrep

      dust
      procs
      sd
      jnv
      glow
      kondo
    ]);
}

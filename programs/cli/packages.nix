{
  inputs,
  pkgs,
  username,
  ...
}:

{
  home-manager.users.${username}.home.packages =
    with inputs;
    [ treefmt.packages.${pkgs.system}.treefmt ]
    ++ (with pkgs; [
      asciinema
      ani-cli
      tokei
      sshx
      just
      lychee
      gping
      hexyl

      sherlock

      onefetch
      cpufetch
      # gpufetch # Not available on nixpkgs

      ouch

      hyperfine
      hurl

      dust
      procs
      sd
      jnv
      glow
      kondo

    ]);
}

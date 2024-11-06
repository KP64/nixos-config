{
  lib,
  config,
  pkgs,
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
    ./zellij.nix
    ./zoxide.nix
  ];

  options.cli.defaults.enable = lib.mkEnableOption "Enable Default Cli Apps";

  config = lib.mkIf config.cli.defaults.enable {
    home-manager.users.${username}.home.packages =
      lib.optional (pkgs.system != "aarch64-linux") pkgs.binsider
      ++ (with pkgs; [
        asciinema
        dipc
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
        # tailspin
        tokei
        treefmt2
        typst
        xh

        ani-cli
        sherlock

        ouch
      ]);
  };
}

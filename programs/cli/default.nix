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
    ./thefuck.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  options.cli.defaults.enable = lib.mkEnableOption "Enable Default Cli Apps";

  config = lib.mkIf config.cli.defaults.enable {
    home-manager.users.${username}.home.packages = with pkgs; [
      ani-cli
      asciinema
      binsider
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
      ouch
      procs
      rustscan
      sd
      sherlock
      sshx
      tokei
      typst
      xh
    ];
  };
}

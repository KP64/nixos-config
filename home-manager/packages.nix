{ inputs, pkgs, ... }:

{
  home.packages =
    with inputs;
    [
      hyprpicker.packages.${pkgs.system}.hyprpicker
      hyprland-contrib.packages.${pkgs.system}.grimblast
      nix-alien.packages.${pkgs.system}.nix-alien
    ]
    ++ (with pkgs; [
      xdg-utils
      libnotify

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

      discord
      webcord
      spicetify-cli
      whatsapp-for-linux

      wineWowPackages.waylandFull
      protonup

      dolphin-emu
      ryujinx
      xemu

      aseprite

      unzip
      wl-clipboard
      grim
      slurp

      exiftool

      hyperfine
      hurl
      gitoxide
      igrep

      dust
      procs
      sd
      jnv
      glow
      kondo

      atlauncher
      steam-run
      pavucontrol
    ]);
}

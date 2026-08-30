{
  den.aspects.kg._.fonts.homeManager = { pkgs, ... }: {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono

      # NOTE: Taken from https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/fonts/packages.nix
      dejavu_fonts
      freefont_ttf
      gyre-fonts
      liberation_ttf
      unifont
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];
  };
}

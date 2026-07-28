{
  den.aspects.kg._.fonts = {
    # TODO: Find out why this is enabled
    nixos.fonts.enableDefaultPackages = false;

    homeManager = { pkgs, ... }: {
      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        nerd-fonts.jetbrains-mono

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
  };
}

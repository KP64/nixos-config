{
  den.aspects.kg.homeManager = { pkgs, ... }: {
    programs.nixvim = {
      extraPackagesAfter = [ pkgs.biber ];

      plugins = {
        # Vimtex handles highlighting
        treesitter.highlight.disable = [ "latex" ];

        texpresso.enable = true;
        vimtex = {
          enable = true;
          # Packages should be collected from the
          # nix devShell of the project to compile
          texlivePackage = null;
        };
      };
    };
  };
}

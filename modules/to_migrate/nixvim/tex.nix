{
  flake.modules.nixvim.tex =
    { pkgs, ... }:
    {
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
}

{
  flake.modules.nixvim.tex =
    { pkgs, ... }:
    {
      extraPackagesAfter = [ pkgs.biber ];

      plugins = {
        texpresso.enable = true;
        vimtex.enable = true;
      };
    };
}

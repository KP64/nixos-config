{
  flake.modules.nixvim.blink-git =
    { pkgs, ... }:
    {
      extraPackagesAfter = [ pkgs.glab ];
      dependencies.gh = {
        enable = true;
        packageFallback = true;
      };
      plugins = {
        blink-cmp-git.enable = true;
        blink-cmp.settings.sources = {
          default = [ "git" ];
          providers.git = {
            module = "blink-cmp-git";
            name = "Git";
            score_offset = 100;
            opts = {
              commit = { };
              git_centers.github = { };
            };
          };
        };
      };
    };
}

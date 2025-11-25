{
  flake.modules.homeManager.users-kg-fetchers =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        onefetch
        cpufetch
        mufetch
        nitch
      ];
      programs.fastfetch.enable = true;
    };
}

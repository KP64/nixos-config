{
  flake.modules.homeManager.users-kg =
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

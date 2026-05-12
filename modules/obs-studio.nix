{
  den.aspects.obs-studio = {
    nixos = {
      programs.obs-studio = {
        enable = true;
        enableVirtualCamera = true;
      };
    };

    homeManager = {
      programs.obs-studio.enable = true;
    };
  };
}

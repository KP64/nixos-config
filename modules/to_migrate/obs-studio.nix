toplevel: {
  flake.modules = {
    nixos.obs-studio = {
      home-manager.sharedModules = [ toplevel.config.flake.modules.homeManager.obs-studio ];

      programs.obs-studio = {
        enable = true;
        enableVirtualCamera = true;
      };
    };

    homeManager.obs-studio = {
      programs.obs-studio.enable = true;
    };
  };
}

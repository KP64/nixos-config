{
  flake.modules = {
    nixos.bluetooth = {
      services.blueman.enable = true;
    };

    homeManager.bluetooth = {
      services.blueman-applet.enable = true;
    };
  };
}

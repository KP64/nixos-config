{
  flake.modules.nixos.sddm = {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}

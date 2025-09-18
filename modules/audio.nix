{
  flake.modules.nixos.audio = {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      raopOpenFirewall = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
  };
}

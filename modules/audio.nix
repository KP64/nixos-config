{ inputs, ... }:
{
  flake.aspects.audio.nixos = {
    imports = [ inputs.musnix.nixosModules.default ];

    musnix = {
      enable = true;
      rtcqs.enable = true;
    };

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

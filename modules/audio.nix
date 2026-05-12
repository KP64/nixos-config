{ inputs, ... }:
{
  flake-file.inputs.musnix = {
    type = "github";
    owner = "musnix";
    repo = "musnix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.audio.nixos = {
    # NOTE: Imports as little as possible
    #       The default module makes use of
    #       unnecessary options and overlays
    imports = [ "${inputs.musnix}/modules/base.nix" ];

    musnix = {
      enable = true;
      rtcqs.enable = true;
    };

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
  };
}

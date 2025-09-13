{
  flake.modules.nixos.sddm =
    { pkgs, ... }:
    {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
      };
    };
}

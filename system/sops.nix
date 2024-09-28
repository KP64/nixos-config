{ pkgs, inputs, ... }:
# TODO: Add Home-manager sops-nix module?
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  environment.systemPackages = with pkgs; [
    age
    rage
    gnupg
    sops
    ssh-to-pgp
    ssh-to-age
  ];
}

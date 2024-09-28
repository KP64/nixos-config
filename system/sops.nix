{ pkgs, inputs, ... }:
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

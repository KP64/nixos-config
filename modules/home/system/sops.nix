{ pkgs, inputs, ... }:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  home.packages = with pkgs; [
    age
    rage
    age-plugin-tpm
    age-plugin-yubikey
    gnupg
    sops
    ssh-to-pgp
    ssh-to-age
  ];
}

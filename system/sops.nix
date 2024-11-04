{
  pkgs,
  inputs,
  username,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  environment = {
    systemPackages = with pkgs; [
      age
      rage
      age-plugin-tpm
      age-plugin-yubikey
      gnupg
      sops
      ssh-to-pgp
      ssh-to-age
    ];
    persistence."/persist".users.${username}.directories = [
      ".config/sops/age"
    ];
  };
}

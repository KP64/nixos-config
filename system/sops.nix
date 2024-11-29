{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  environment = lib.mkMerge [
    {
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
    }

    (lib.mkIf config.system.impermanence.enable {
      persistence."/persist".users.${username}.directories = [ ".config/sops/age" ];
    })
  ];
}

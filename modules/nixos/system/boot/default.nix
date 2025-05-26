{ lib, pkgs, ... }:
{
  imports = [ ./efi.nix ];

  config.boot =
    {
      kernelPackages = pkgs.linuxPackages_zen;
    }
    |> lib.optionalAttrs (!pkgs.stdenv.isAarch64)
    |> lib.mergeAttrs { tmp.cleanOnBoot = true; }
    |> lib.mkDefault;
}

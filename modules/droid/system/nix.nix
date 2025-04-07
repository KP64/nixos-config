{ pkgs, ... }:
{
  environment.etcBackupExtension = ".bak";
  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes pipe-operators no-url-literals
    '';
  };
}

{ pkgs, ... }:
{
  environment = {
    etcBackupExtension = ".bak";
    packages = with pkgs; [
      gnused
      gnugrep      
    ];
  };

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes pipe-operators no-url-literals
    '';
  };
}

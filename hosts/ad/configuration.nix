{ stateVersion, ... }:
{
  editors.helix.enable = true;

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  system = {
    inherit stateVersion;
  };

  time.timeZone = "Europe/Berlin";

  # Configure home-manager
  home-manager.backupFileExtension = "hm-bak";
}

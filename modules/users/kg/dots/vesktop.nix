{
  flake.modules.homeManager.users-kg = {
    programs.vesktop = {
      enable = true;
      settings.minimizeToTray = false;
      vencord.settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        # TODO: Add more needed plugins
        plugins = {
          AnonymiseFileNames.enabled = true;

          BetterFolders = {
            enabled = true;
            sidebar = false;
            closeAllFolders = true;
            closeAllHomeButton = true;
            closeOthers = true;
          };
          BetterRoleDot.enabled = true;
          BetterSessions.enabled = true;
          BetterUploadButton.enabled = true;

          CallTimer.enabled = true;
          CopyFileContents.enabled = true;

          Dearrow.enabled = true;

          FakeNitro.enabled = true;

          MessageLogger.enabled = true;

          SilentTyping.enabled = true;
          StreamerModeOnStream.enabled = true;

          TypingIndicator.enabled = true;
          TypingTweaks.enabled = true;

          WhoReacted.enabled = true;
        };
      };
    };
  };
}

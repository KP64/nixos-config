{
  flake.modules.homeManager.users-kg-vesktop = {
    programs.vesktop = {
      # enable = true;
      settings.minimizeToTray = false;
      vencord.settings.plugins = {
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
        FullUserInChatbox.enabled = true;
        FullSearchContext.enabled = true;
        ImageLink.enabled = true;
        MentionAvatars.enabled = true;
        MessageClickActions.enabled = true;
        NoUnblockToJump.enabled = true;
        PinDMs.enabled = true;
        QuickMention.enabled = true;
        QuickReply.enabled = true;
        RelationshipNotifier.enabled = true;
        ShowConnections.enabled = true;
        ThemeAttributes.enabled = true;
        Unindent.enabled = true;
        UserVoiceShow.enabled = true;
        ValidReply.enabled = true;
        ValidUser.enabled = true;
        VoiceChatDoubleClick.enabled = true;
        WhoReacted.enabled = true;
      };
    };
  };
}

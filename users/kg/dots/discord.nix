{
  programs.nixcord = {
    enable = true;
    config = {
      themeLinks = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css" ];
      plugins = {
        accountPanelServerProfile.enable = true;
        alwaysAnimate.enable = true;
        anonymiseFileNames.enable = true;
        betterFolders = {
          enable = true;
          sidebar = false;
          closeAllFolders = true;
          closeAllHomeButton = true;
          closeOthers = true;
        };
        betterRoleContext.enable = true;
        betterRoleDot = {
          enable = true;
          bothStyles = true;
          copyRoleColorInProfilePopout = true;
        };
        betterSessions = {
          enable = true;
          backgroundCheck = true;
        };
        betterSettings.enable = true;
        betterUploadButton.enable = true;
        callTimer.enable = true;
        clearURLs.enable = true;
        consoleJanitor.enable = true;
        copyFileContents.enable = true;
        dearrow.enable = true;
        disableCallIdle.enable = true;
        fakeNitro.enable = true;
        favoriteEmojiFirst.enable = true;
        fixCodeblockGap.enable = true;
        fixImagesQuality.enable = true;
        friendsSince.enable = true;
        fullSearchContext.enable = true;
        fullUserInChatbox.enable = true;
        gameActivityToggle.enable = true;
        gifPaste.enable = true;
        imageZoom.enable = true;
        implicitRelationships = {
          enable = true;
          sortByAffinity = true;
        };
        mentionAvatars.enable = true;
        messageClickActions.enable = true;
        messageLinkEmbeds = {
          enable = true;
          messageBackgroundColor = true;
        };
        messageLogger.enable = true;
        mutualGroupDMs.enable = true;
        newGuildSettings.enable = true;
        noUnblockToJump.enable = true;
        openInApp = {
          enable = true;
          spotify = true;
          steam = true;
          epic = true;
        };
        pinDMs.enable = true;
        quickMention.enable = true;
        relationshipNotifier = {
          enable = true;
          notices = true;
        };
        replyTimestamp.enable = true;
        revealAllSpoilers.enable = true;
        reverseImageSearch.enable = true;
        shikiCodeblocks = {
          enable = true;
          theme = "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/refs/heads/main/packages/tm-themes/themes/catppuccin-mocha.json";
        };
        showConnections.enable = true;
        silentTyping = {
          enable = true;
          showIcon = true;
        };
        stickerPaste.enable = true;
        streamerModeOnStream.enable = true;
        typingIndicator = {
          enable = true;
          includeMutedChannels = true;
          includeBlockedUsers = true;
        };
        typingTweaks.enable = true;
        userVoiceShow.enable = true;
        voiceChatDoubleClick.enable = true;
        webScreenShareFixes.enable = true;
        whoReacted.enable = true;
        youtubeAdblock.enable = true;
      };
    };
  };
}

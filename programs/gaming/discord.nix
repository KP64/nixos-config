{ inputs, username, ... }:
{
  home-manager.users.${username} = {
    imports = [ inputs.nixcord.homeManagerModules.nixcord ];

    programs.nixcord = {
      enable = true;
      config = {
        themeLinks = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css" ];
        plugins = {
          alwaysAnimate.enable = true;
          anonymiseFileNames.enable = true;
          betterFolders = {
            enable = true;
            sidebar = false;
          };
          betterGifAltText.enable = true;
          betterRoleContext.enable = true;
          betterRoleDot.enable = true;
          betterSessions.enable = true;
          betterSettings.enable = true;
          betterUploadButton.enable = true;
          blurNSFW.enable = true;
          callTimer.enable = true;
          clearURLs.enable = true;
          consoleJanitor = {
            enable = true;
            disableNoisyLoggers = true;
          };
          copyUserURLs.enable = true;
          customIdle.enable = true;
          dearrow.enable = true;
          decor.enable = true;
          disableCallIdle.enable = true;
          dontRoundMyTimestamps.enable = true;
          emoteCloner.enable = true;
          fakeNitro.enable = true;
          favoriteEmojiFirst.enable = true;
          fixCodeblockGap.enable = true;
          fixSpotifyEmbeds.enable = true;
          fixYoutubeEmbeds.enable = true;
          friendsSince.enable = true;
          gameActivityToggle.enable = true;
          imageZoom.enable = true;
          mentionAvatars.enable = true;
          nsfwGateBypass.enable = true;
          pictureInPicture.enable = true;
          pinDMs.enable = true;
          platformIndicators.enable = true;
          readAllNotificationsButton.enable = true;
          relationshipNotifier.enable = true;
          reverseImageSearch.enable = true;
          showConnections.enable = true;
          showMeYourName.enable = true;
          silentTyping.enable = true;
          streamerModeOnStream.enable = true;
          superReactionTweaks.enable = true;
          typingIndicator.enable = true;
          typingTweaks.enable = true;
          userVoiceShow.enable = true;
          USRBG.enable = true;
          voiceChatDoubleClick.enable = true;
          voiceMessages.enable = true;
          whoReacted.enable = true;
          youtubeAdblock.enable = true;
        };
      };
    };
  };
}

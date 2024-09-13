{
  lib,
  config,
  inputs,
  username,
  ...
}:
{
  options.gaming.discord.enable = lib.mkEnableOption "Enable Discord";

  config = lib.mkIf config.gaming.discord.enable {
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
              closeAllFolders = true;
              closeAllHomeButton = true;
              closeOthers = true;
              forceOpen = true;
            };
            betterGifAltText.enable = true;
            betterRoleContext.enable = true;
            betterRoleDot = {
              enable = true;
              bothStyles = true;
              copyRoleColorInProfilePopout = true;
            };
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
            copyFileContents.enable = true;
            copyUserURLs.enable = true;
            customIdle.enable = true;
            dearrow.enable = true;
            decor.enable = true;
            disableCallIdle.enable = true;
            dontRoundMyTimestamps.enable = true;
            emoteCloner.enable = true;
            fakeNitro.enable = true;
            fakeProfileThemes.enable = true;
            favoriteEmojiFirst.enable = true;
            fixCodeblockGap.enable = true;
            fixSpotifyEmbeds.enable = true;
            fixYoutubeEmbeds.enable = true;
            friendInvites.enable = true;
            friendsSince.enable = true;
            gameActivityToggle.enable = true;
            greetStickerPicker.enable = true;
            imageZoom.enable = true;
            implicitRelationships.enable = true;
            mentionAvatars.enable = true;
            noRPC.enable = true;
            nsfwGateBypass.enable = true;
            pictureInPicture.enable = true;
            pinDMs.enable = true;
            platformIndicators.enable = true;
            readAllNotificationsButton.enable = true;
            relationshipNotifier.enable = true;
            reverseImageSearch.enable = true;
            shikiCodeblocks = {
              enable = true;
              # TODO: When nixcord moves to new Shiki Versions use the Catppuccin theme by Shiki
              theme = "https://raw.githubusercontent.com/shikijs/shiki/v0/packages/shiki/themes/material-theme-ocean.json";
            };
            showConnections.enable = true;
            showMeYourName.enable = true;
            silentTyping = {
              enable = true;
              showIcon = true;
            };
            spotifyShareCommands.enable = true;
            streamerModeOnStream.enable = true;
            superReactionTweaks.enable = true;
            themeAttributes.enable = true;
            typingIndicator = {
              enable = true;
              includeMutedChannels = true;
              includeBlockedUsers = true;
            };
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
  };
}

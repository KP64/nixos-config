{
  lib,
  config,
  inputs,
  username,
  ...
}:
let
  cfg = config.gaming.discord;
in

{
  options.gaming.discord.enable = lib.mkEnableOption "Discord";

  config = lib.mkMerge [
    {
      home-manager.users.${username} = {
        imports = [ inputs.nixcord.homeManagerModules.nixcord ];

        programs.nixcord = {
          inherit (cfg) enable;
          vesktop.enable = true;
          config = {
            themeLinks = lib.optional config.isCatppuccinEnabled "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
            frameless = true;
            plugins = {
              accountPanelServerProfile.enable = true;
              alwaysAnimate.enable = true;
              alwaysExpandRoles.enable = true;
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
              clearURLs.enable = true;
              consoleJanitor.enable = true;
              copyFileContents.enable = true;
              copyUserURLs.enable = true;
              dearrow.enable = true;
              disableCallIdle.enable = true;
              dontRoundMyTimestamps.enable = true;
              emoteCloner.enable = true;
              fakeNitro.enable = true;
              fakeProfileThemes.enable = true;
              favoriteEmojiFirst.enable = true;
              fixCodeblockGap.enable = true;
              fixImagesQuality.enable = true;
              fixSpotifyEmbeds.enable = true;
              fixYoutubeEmbeds.enable = true;
              friendInvites.enable = true;
              friendsSince.enable = true;
              fullSearchContext.enable = true;
              gameActivityToggle.enable = true;
              gifPaste.enable = true;
              greetStickerPicker.enable = true;
              imageZoom.enable = true;
              implicitRelationships.enable = true;
              mentionAvatars.enable = true;
              messageClickActions.enable = true;
              messageLogger.enable = true;
              messageTags.enable = true;
              mutualGroupDMs.enable = true;
              newGuildSettings.enable = true;
              noRPC.enable = true;
              noScreensharePreview.enable = true;
              nsfwGateBypass.enable = true;
              pictureInPicture.enable = true;
              pinDMs.enable = true;
              platformIndicators.enable = true;
              readAllNotificationsButton.enable = true;
              relationshipNotifier.enable = true;
              reverseImageSearch.enable = true;
              shikiCodeblocks = {
                enable = true;
                theme = lib.optionalString config.isCatppuccinEnabled "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/refs/heads/main/packages/tm-themes/themes/catppuccin-mocha.json";
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
    }

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories =
        lib.optional cfg.enable ".config/vesktop";
    })
  ];
}

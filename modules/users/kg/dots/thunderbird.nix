toplevel: {
  # TODO: Add email auth, encryption and signing
  flake.aspects.users-kg-thunderbird.homeManager =
    { config, ... }:
    let
      inherit (config.home) username;
      inherit (toplevel.config.lib.flake.util) toFlattenedByDots;
    in
    {
      catppuccin.thunderbird.profile = username;

      programs.gpg = {
        enable = true;
        # publicKeys = [
        #   {
        #     source = ./.;
        #     text = null;
        #     trust = null;
        #   }
        # ];
        # settings = {
        # };
      };
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        # sshKeys = null;
      };

      accounts.email.accounts.${username} = {
        primary = true;
        address = config.invisible.email;
        realName = "${config.invisible.firstName} ${config.invisible.lastName}";
        userName = username;
        # gpg = {
        #   encryptByDefault = true;
        #   signByDefault = true;
        #   key = config.sops.secrets.email_gpg.path;
        # };
        thunderbird.enable = true;
      };

      programs.thunderbird = {
        enable = true;
        profiles.${username} = {
          isDefault = true;
          withExternalGnupg = true;
          search = {
            default = "ddg";
            privateDefault = "ddg";
            force = true;
          };
          settings = toFlattenedByDots {
            extensions.autoDisableScopes = 0;
            general.autoScroll = true;
            privacy.donottrackheader.enabled = true;
            toolkit.telemetry.server = "";
            network.trr.mode = 5; # Off by choice -> Uses system DNS resolver
            mail.e2ee = {
              auto_enable = true;
              auto_disable = true;
            };
          };
        };
      };
    };
}

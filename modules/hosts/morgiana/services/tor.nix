{
  den.aspects.morgiana = {
    _.to-users = { user, ... }: {
      nixos = { config, lib, ... }: {
        users.users.${user.name}.extraGroups =
          lib.optional config.services.tor.enable config.users.groups.tor.name;
      };
      homeManager =
        {
          osConfig ? null,
          lib,
          pkgs,
          ...
        }:
        {
          home.packages = lib.optional (osConfig.services.tor.enable or false) pkgs.nyx;
        };
    };

    nixos.services.tor = {
      enable = true;
      openFirewall = true;
      controlSocket.enable = true;
      settings = {
        # NOTE: This and the "tor" group are needed for the control Socket
        CookieAuthFileGroupReadable = true;
        DataDirectoryGroupReadable = true;

        Nickname = "Torrifics";
        # Specifically created for this.
        ContactInfo = "torrifics@proton.me";

        SocksPort = 0;
        ORPort = [ 9001 ];
        CookieAuthentication = true;

        ProtocolWarnings = true;
        HardwareAccel = 1;

        # I hate my country's ISP internet plans...
        RelayBandwidthRate = "3 MB";
        RelayBandwidthBurst = "4 MB";
      };
      relay = {
        enable = true;
        role = "relay";
      };
    };
  };
}

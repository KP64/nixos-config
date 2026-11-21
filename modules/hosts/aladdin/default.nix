{ den, ... }: {
  den = {
    hosts.aladdin = {
      users.kg.isAdmin = true;

      isGamingCapable = true;
      isGraphical = true;
      isConfigBuilder = true;
      isServer = false;
      isUsedInteractively = true;

      settings.yubikey.lockOnRemoval = false;
    };

    aspects.aladdin = {
      includes = with den.aspects; [
        boot._.secure
        catppuccin
        nvidia
        tpm
      ];

      nixos.services.xserver.xkb.layout = "de";
    };
  };
}

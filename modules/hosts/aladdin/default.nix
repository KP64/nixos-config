{ den, ... }: {
  den = {
    hosts.aladdin = {
      users.kg.isAdmin = true;

      isGamingCapable = true;
      isGraphical = true;
      isServer = false;
      isUsedInteractively = true;
      hasTPM = true;
    };

    aspects.aladdin = {
      includes = with den.aspects; [
        boot._.secure
        nvidia
      ];

      nixos = {
        services.xserver.xkb.layout = "de";
        boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
      };
    };
  };
}

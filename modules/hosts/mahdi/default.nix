{
  den = {
    hosts.mahdi = {
      users.kg.isAdmin = true;

      isServer = true;
    };

    aspects.mahdi = {
      nixos = {
        boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
        security.tpm2.enable = false;
      };
    };
  };
}

{
  den = {
    hosts.mahdi = {
      users.kg.isAdmin = true;

      isServer = true;
      # TODO: Get correct addr
      settings.static-ip.v6 = "bogus";
      # staticIPv6 = "${config.lib.topology.getHomeCidr6}::${addr}";

    };

    aspects.mahdi.nixos = {
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
      security.tpm2.enable = false;
    };
  };
}

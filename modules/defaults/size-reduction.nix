{
  den.default.nixos = { lib, ... }: {
    documentation.enable = false;
    environment = {
      defaultPackages = [ ];
      stub-ld.enable = false;
    };
    fonts.fontconfig.enable = lib.mkDefault false;
    system.tools.nixos-generate-config.enable = false;
  };
}

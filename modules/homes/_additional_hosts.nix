{
  sindbad = {
    system = "x86_64-linux";
    modules = [
      { targets.genericLinux.enable = true; }
      # NOTE: allow user kg specifically for now (see why in ../nix.nix)
      { nix.settings.trusted-users = [ "kg" ]; }
    ];
  };
}

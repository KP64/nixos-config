{
  # TODO: Replace with flake-parts module
  #        - Custom Flake-Parts Hosts option needed
  sindbad = {
    system = "x86_64-linux";
    modules = [ { targets.genericLinux.enable = true; } ];
  };
}

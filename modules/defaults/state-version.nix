{
  den.default =
    let
      # WARNING: Only change this when absolutely sure it is fine.
      stateVersion = "26.11";
    in
    {
      nixos.system = { inherit stateVersion; };
      homeManager.home = { inherit stateVersion; };
    };
}

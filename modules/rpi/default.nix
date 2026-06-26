{
  flake-file.inputs.nixos-raspberrypi = {
    type = "github";
    owner = "nvmd";
    repo = "nixos-raspberrypi";
    inputs = {
      flake-compat.follows = "";
      nixpkgs.follows = "nixpkgs";
    };
  };
}

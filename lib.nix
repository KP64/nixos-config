{ nixpkgs, inputs }:
{
  mkSystem =
    { username, system }:
    let
      stateVersion = "24.05";
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs username stateVersion;
      };
      modules =
        with inputs;
        [ home-manager.nixosModules.default ]
        ++ [
          ./hosts/${username}/configuration.nix
          ./desktop
          ./hardware
          ./programs
          ./system
          {
            nixpkgs.overlays = with inputs; [ nur.overlay ];
            home-manager = {
              extraSpecialArgs = {
                inherit inputs username stateVersion;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username}.imports = [ ./hosts/${username}/home.nix ];
            };
          }
        ];
    };
}

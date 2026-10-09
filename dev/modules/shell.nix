{
  perSystem =
    {
      lib,
      pkgs,
      inputs',
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "config";

        packages =
          let
            writeCustomScript =
              name: packages:
              let
                prefixPath = packages: {
                  makeWrapperArgs = [
                    "--prefix"
                    "PATH"
                    ":"
                    (lib.makeBinPath packages)
                  ];
                };
              in
              pkgs.writers.writeNuBin name (lib.optionalAttrs (packages != [ ]) (prefixPath packages)) (
                builtins.readFile ../scripts/${name}.nu
              );
          in
          (with pkgs; [
            nil
            yaml-language-server
            vscode-json-languageserver

            nix-init
            nix-melt
            nix-output-monitor
          ])
          ++ [
            (writeCustomScript "topo" (
              with pkgs;
              [
                nix-output-monitor
                kitty
              ]
            ))
            (writeCustomScript "upin" (
              with pkgs;
              [
                nixVersions.latest
                gum
              ]
            ))
            # TODO: Move this to minecraft aspect. Hosts without config but run MC benefit from this.
            (writeCustomScript "minecraft" [
              pkgs.tmux
              inputs'.nix-minecraft.packages.nix-modrinth-prefetch
            ])
            (writeCustomScript "deploy" (
              with pkgs;
              [
                sops
                gitMinimal
                ssh-to-age
                nixos-anywhere
                openssh
              ]
            ))
          ];
      };
    };
}

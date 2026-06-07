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
            prefixPath = packages: {
              makeWrapperArgs = [
                "--prefix"
                "PATH"
                ":"
                (lib.makeBinPath packages)
              ];
            };

            writeCustomScript =
              name: packages:
              pkgs.writers.writeNuBin name (if packages != [ ] then prefixPath packages else { }) (
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
            (writeCustomScript "attach" [ pkgs.tmux ])
            (writeCustomScript "prefetch" [ inputs'.nix-minecraft.packages.nix-modrinth-prefetch ])
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

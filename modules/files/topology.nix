{ config, ... }: {
  perSystem =
    {
      system,
      lib,
      pkgs,
      ...
    }:
    {
      files.file =
        let
          formatTopology =
            file:
            pkgs.runCommand "formatted-topology" { } ''
              cp ${config.flake.topology.${system}.config.output}/${file} ${file}

              ${lib.getExe config.flake.formatter.${system}} --no-cache --tree-root-file ${file}

              cat ${file} > "$out"
            '';
        in
        builtins.listToAttrs
        <| map (file: {
          name = "assets/topology/${file}";
          value.source = formatTopology file;
        })
        <| [
          "main.svg"
          "network.svg"
        ];
    };
}

toplevel@{ self, ... }:
{
  perSystem =
    { lib, pkgs, ... }:
    let
      inherit (toplevel.config.lib.flake.util) getRelativePath;

      hostCfgs =
        toplevel.config.flake.nixosConfigurations
        |> builtins.mapAttrs (
          _: host:
          let
            counts =
              host.config.hardware.facter.report.hardware.cpu
              |> lib.groupBy (cpu: cpu.model_name or cpu.vendor_name)
              |> builtins.mapAttrs (_: builtins.length);
          in
          {
            name = host.config.networking.hostName;
            arch = host.config.hardware.facter.report.system;
            hardware =
              counts
              |> builtins.mapAttrs (cpu: num: if num == 1 then cpu else "${toString num}x${cpu}")
              |> builtins.attrValues
              |> builtins.concatStringsSep ", ";
          }
        )
        |> builtins.attrValues;

      headers = [
        "Name"
        "Hardware"
        "Arch"
      ];
      mkCfgHosts =
        let
          transpose =
            lists:
            lib.optionals (lists != [ ] && builtins.head lists != [ ]) (
              [ (map builtins.head lists) ] ++ transpose (map builtins.tail lists)
            );
          columns = lib.forEach headers (
            def:
            let
              values =
                hostCfgs
                |> map (infos: infos.${lib.toLower def})
                |> map (h: if def == "Name" then "[${h}](${getRelativePath "${self}/modules/hosts/${h}"})" else h);

              maxLen = lib.foldl' (x: y: if x > y then x else y) 0 (
                [ (builtins.stringLength def) ] ++ map builtins.stringLength values
              );

              pad = len: ch: ch |> lib.replicate (maxLen - len) |> lib.concatStrings;

              cell = s: " ${s}${pad (builtins.stringLength s) " "} ";
            in
            [
              (cell def)
              " :${pad 2 "-"}: "
            ]
            ++ map cell values
          );

          rows = transpose columns;
        in
        lib.concatMapStringsSep "\n" (row: "|${lib.concatStringsSep "|" row}|") rows;

      readme = # html
        ''
          # Nix Config

          <div align="center">

          ![GitHub Repo stars](https://img.shields.io/github/stars/KP64/nixos-config?style=for-the-badge&logo=starship&logoColor=%23cad3f5&labelColor=%23181825&color=%2311111B)
          ![GitHub repo size](https://img.shields.io/github/repo-size/KP64/nixos-config?style=for-the-badge&logo=github&logoColor=%23cad3f5&labelColor=%23181825&color=%2311111B)
          ![Static Badge](https://img.shields.io/badge/nixos-unstable-blue?style=for-the-badge&logo=nixos&logoColor=%23cad3f5&labelColor=%23181825&color=%2311111B)
          ![Static Badge](https://img.shields.io/badge/unlicense-%2311111b?style=for-the-badge&logo=unlicense&logoColor=%23cdd6f4&labelColor=%23181825)

          </div>

          ## 📝 About

          A wannabe size fits it all NixOS Configuration using flakes.
          It is encouraged to try, modify and break it all you like!
          Don't believe me? Look at the ["License"](${baseNameOf "${self}/UNLICENSE"}) :D

          ## Hosts

          ${mkCfgHosts}

          > [!Note]
          > Some hosts like `sindbad` are not managed by Nix and therefore not added here.
          > The users on these hosts are managed via standalone Home-Manager.

          ## Gallery

          <details open>
            <summary>Catppuccin</summary>
            <img alt="Terminal" src="${getRelativePath "${self}/assets/gallery/catppuccin/terminal.png"}" />
            <img alt="Idle" src="${getRelativePath "${self}/assets/gallery/catppuccin/idle.png"}" />
            <img alt="Firefox" src="${getRelativePath "${self}/assets/gallery/catppuccin/firefox.png"}" />
          </details>

          ## 🌐 Network Topology
          ![Main](${getRelativePath "${self}/assets/topology/main.svg"})

          ![Net](${getRelativePath "${self}/assets/topology/network.svg"})
        '';
    in
    {
      files.file."README.md".source =
        pkgs.runCommand "formatted-readme.md" { nativeBuildInputs = [ pkgs.prettier ]; }
          ''
            cat > input.md <<'EOF'
            ${readme}
            EOF

            prettier \
              --parser markdown \
              input.md \
              > "$out"
          '';
    };
}

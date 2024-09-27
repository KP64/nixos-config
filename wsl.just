
build host="ws":
  sudo nix run .#nixosConfigurations.{{ host }}.config.system.build.tarballBuilder

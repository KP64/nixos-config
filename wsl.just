[doc('Build a WSL tarball. 
Note: It is not symlinked as a result.')]
build host="ws":
  sudo nix run .#nixosConfigurations.{{ host }}.config.system.build.tarballBuilder

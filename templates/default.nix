{
  rust = {
    path = ./rust;
    description = "Fully featured rust development flake";
    welcomeText = ''
      # Getting started
      1. cd into the project
      2. `nix develop` or `direnv allow`
      3. `cargo init .`
      4. `cargo r`

      # Nix the project
      1. `cargo b` (to generate Cargo.lock if not present)
      2. Set the pname in `package.nix` to your current project
      3. `git add -A` (needed once only)
      3. `nix build` or `nix run` to build or run respectively
    '';
  };
}

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global = {
      disable_stdin = true;
    };
  };
}

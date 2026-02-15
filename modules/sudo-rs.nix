{
  flake.aspects.sudo.nixos = {
    security.sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };
}

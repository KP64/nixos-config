{
  flake.modules.nixos.sudo = {
    security.sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };
}

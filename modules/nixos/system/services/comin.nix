{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.system.services.comin;

  toMinutes = sec: 60 * sec;
in
{
  imports = [ inputs.comin.nixosModules.comin ];

  options.system.services.comin.enable = lib.mkEnableOption "Comin";

  config.services.comin = {
    inherit (cfg) enable;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/KP64/nixos-config.git";
        poller.period = toMinutes 5;
        # No testing branch on this remote
        branches.testing.name = "";
      }
    ];
    # exporter = { }; # TODO: For prometheus
  };
}

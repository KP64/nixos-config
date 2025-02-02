{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.system.services.comin;
in
{
  imports = [ inputs.comin.nixosModules.comin ];

  options.system.services.comin.enable = lib.mkEnableOption "Comin" // {
    default = true;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.comin = {
        enable = true;
        remotes = [
          {
            name = "origin";
            url = "https://github.com/KP64/nixos-config.git";
            poller.period = 60 * 5; # 5 min
            # No testing branch on this remote
            branches.testing.name = "";
          }
        ];
        # exporter = { }; # TODO: For prometheus
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories = lib.optional cfg.enable "/var/lib/comin";
    })
  ];
}

{
  den.aspects.aladdin.nixos = { config, ... }: {
    topology.self = {
      hardware.info = (builtins.head config.hardware.facter.report.hardware.cpu).model_name;
      # TODO: Interfaces can be out of sync. Check if it exists in host cfg.
      #         if no -> abort evaluation
      interfaces.wlp7s0.network = "home";
    };
  };
}

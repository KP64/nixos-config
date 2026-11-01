{
  den.aspects.aladdin.nixos = { config, ... }: {
    topology.self = {
      hardware.info = (builtins.head config.hardware.facter.report.hardware.cpu).model_name;
      # TODO: Generate host interfaces from topology info
      interfaces.wlp7s0.network = "home";
    };
  };
}

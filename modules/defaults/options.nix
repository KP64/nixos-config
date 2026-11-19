{ lib, ... }: {
  den.schema.host.options = {
    isUsedInteractively = lib.mkEnableOption "Machine is interactively used";
    isGraphical = lib.mkEnableOption "Machine can run Graphical applications";
    # TODO: populate default logic with other types of Servers.
    isServer = lib.mkOption {
      type = lib.types.bool;
      example = true;
      description = "Whether the machine is a Server";
    };
  };
}

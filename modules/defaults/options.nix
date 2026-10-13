{ lib, ... }: {
  den.schema.host = { config, ... }: {
    options = {
      isUsedInteractively = lib.mkEnableOption "Machine is interactively used";
      isGraphical = lib.mkEnableOption "Machine can run Graphical applications";
      isServer = lib.mkOption {
        type = lib.types.bool;
        # TODO: populate default logic with other types of Servers.
        default = config.isNTPServer;
        example = true;
        description = "Whether the machine is a Server";
      };
    };
  };
}

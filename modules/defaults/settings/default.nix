{ den, lib, ... }: {
  den = {
    reservedKeys = [ "settings" ];

    schema.conf.options.settings = lib.mkOption {
      type = import ./_settings-type.nix { inherit den lib; };
      default = { };
      description = "Per-aspect typed settings";
    };
  };
}

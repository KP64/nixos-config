{ config, lib, ... }:
{
  imports = [
    ./ollama.nix
    ./open-webui.nix
    ./tabby.nix
  ];

  config = lib.mkIf config.isImpermanenceEnabled {
    environment.persistence."/persist".directories = [
      {
        directory = "/var/lib/private";
        mode = "0700";
      }
    ];
  };
}

{
  lib,
  config,
  inputs,
  ...
}:
{
  options.system.autoupgrade.enable = lib.mkEnableOption "Enable System Auto Upgrading";

  config = lib.mkIf config.system.autoupgrade.enable {
    system.autoUpgrade = {
      enable = true;
      allowReboot = true;
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "--commit-lock-file"
        "-L"
      ];
    };
  };
}

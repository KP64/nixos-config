{
  # TODO: Flesh out yubi modules
  #       MFA and locking in a strict mode?
  flake.modules = {
    nixos.yubikey =
      { lib, pkgs, ... }:
      {
        programs.yubikey-manager.enable = true;
        services.yubikey-agent.enable = true;
        security.pam.yubico = {
          enable = true;
          mode = "challenge-response";
          # control = "required";
        };

        # Taken from: https://wiki.nixos.org/wiki/Yubikey#Locking_the_screen_when_a_Yubikey_is_unplugged
        services.udev.extraRules = ''
          ACTION=="remove",\
           ENV{ID_BUS}=="usb",\
           ENV{ID_MODEL_ID}=="0407",\
           ENV{ID_VENDOR_ID}=="1050",\
           ENV{ID_VENDOR}=="Yubico",\
           RUN+="${lib.getExe' pkgs.systemd "loginctl"} lock-sessions"
        '';
      };

    homeManager.yubikey = {
      services.yubikey-agent.enable = true;
    };
  };
}

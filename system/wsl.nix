{
  inputs,
  wsl,
  username,
  ...
}:
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];
  wsl = {
    enable = wsl;
    defaultUser = username;
    useWindowsDriver = true;
    interop.register = true;
    startMenuLaunchers = true;
    usbip.enable = true;
  };
}

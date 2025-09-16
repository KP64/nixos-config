{ customLib, ... }:
{
  imports = customLib.fs.scanPath ./.;
}

{ lib, ... }:
{
  imports = lib.custom.fs.scanPath ./.;
}

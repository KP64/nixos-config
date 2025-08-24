{ lib, ... }:
{
  imports = lib.custom.scanPath ./.;
}

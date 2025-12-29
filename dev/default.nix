{ customLib, ... }:
{
  imports = customLib.fs.scanPath { p = ./.; };
}

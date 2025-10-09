{ customLib, ... }:
{
  imports = customLib.fs.scanPath { path = ./.; };
}

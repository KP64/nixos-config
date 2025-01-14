#!/usr/bin/env -S nix shell nixpkgs#bash nixpkgs#pamixer --command bash

if [ "$(pamixer --get-mute)" == true ]; then
  echo 0
  exit
else
  pamixer --get-volume
fi

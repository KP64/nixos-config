{ self, ... }: {
  den.aspects.secrets._.porkbun.nixos = { lib, ... }: {
    sops.secrets =
      let
        sopsFile = "${self}/secrets/porkbun.yaml";
      in
      lib.genAttrs' [ "api_key" "secret_api_key" ] (
        key: lib.nameValuePair "porkbun/${key}" { inherit sopsFile key; }
      );
  };
}

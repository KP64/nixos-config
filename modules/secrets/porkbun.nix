{ self, ... }: {
  den.aspects.secrets._.porkbun.nixos = {
    sops.secrets =
      let
        sopsFile = "${self}/secrets/porkbun.yaml";
      in
      {
        "porkbun/api_key" = {
          inherit sopsFile;
          key = "api_key";
        };
        "porkbun/secret_api_key" = {
          inherit sopsFile;
          key = "secret_api_key";
        };
      };
  };
}

{
  config,
  invisible,
  rootPath,
  ...
}:
{
  imports = [ ./disko-config.nix ];

  facter.reportPath = ./facter.json;

  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      "users/sv/password".neededForUsers = true;
      acme_credentials = { };
    };
  };

  security = {
    polkit.enable = true;

    acme =
      let
        inherit (config.networking) domain;
      in
      {
        acceptTerms = true;
        certs.${domain} = {
          inherit (invisible) email;
          dnsProvider = "ipv64";
          credentialFiles.IPV64_API_KEY_FILE = config.sops.secrets.acme_credentials.path;
          group = "traefik";
          extraDomainNames = [ "*.${domain}" ];
        };
      };
  };

  system = {
    stateVersion = "25.11";
    boot.efi.enable = true;
    security = {
      tpm.enable = true;
      sudo-rs.enable = true;
    };
    services.ssh.enable = true;
    style.catppuccin.enable = true;
  };

  systemd.network = {
    enable = true;
    networks."10-eno3" = rec {
      name = "eno3";
      linkConfig.RequiredForOnline = "routable";
      address = [ "192.168.2.108/24" ];
      gateway = [
        "192.168.2.1"
        "fe80::1"
      ];
      dns = gateway;
      networkConfig = {
        DNSSEC = "yes";
        DNSOverTLS = "yes";
        IPv6AcceptRA = "yes";
        IPv6PrivacyExtensions = "yes";
      };
    };
  };

  networking = {
    domain = "holab.ipv64.de";
    firewall.allowPing = false;
  };

  time.timeZone = "Europe/Berlin";

  topology.self = {
    hardware = {
      info = "Dell Poweredge R730";
      image = "${rootPath}/assets/topology/devices/poweredge730.png";
    };
    interfaces.eno3 =
      let
        inherit (config.lib) topology;
      in
      {
        network = "home";
        physicalConnections = [ (topology.mkConnectionRev "router" "eth3") ];
      };
  };


  services = {
    ollama = {
      enable = true;
      loadModels = [
        "deepseek-r1:1.5b"
        "deepseek-r1:70b"
        "llama3.2"
        "llama3.1"
        "paraphrase-multilingual:278m"
        "all-minilm:l6-v2"
      ];
    };
    ai = {
      open-webui = {
        enable = true;
        ollamaUrls =
          let
            ollamaPort = toString config.services.ollama.port;
          in
          [
            "http://localhost:${ollamaPort}"
            "http://192.168.2.112:${ollamaPort}"
          ];
      };
      tabby.enable = true;
    };

    media = {
      dumb.enable = true;
      # immich = {
      #   enable = true;
      #   secretsFile = null; # TODO
      # };
      invidious.enable = true;
      # jellyfin.enable = true;
      # jellyseerr.enable = true; # TODO: Needs *arr Services first
      # komga.enable = true;
      redlib.enable = true;
      stirling-pdf.enable = true;
    };

    # metrics.netdata.enable = true; # FIX

    misc = {
      # anki = { # TODO
      #   enable = true;
      #   users = [ { } ];
      # };
      atuin.enable = true; # TODO: Sign in
      # firefox-sync.enable = true;
      # forgejo.enable = true;
      glance = {
        enable = true;
        inherit (invisible.glance) location;
      };
      languagetool.enable = true;
      # searxng.enable = true; # TODO
    };

    networking = {
      # adguard = { # TODO
      #   enable = true;
      #   allowedServices = [ ];
      #   rewrites = [ ];
      #   users = [ ];
      # };
      i2p.enable = true;
      tor.enable = true;
      traefik.enable = true;
      # wireguard.enable = true; # TODO
    };

    security = {
      fail2ban.enable = true;
      # vaultwarden.enable = true; # TODO
    };

    gaming.minecraft.servers.Warden = {
      openFirewall = true;
      version = "1.21.4";
      ram = 24;
      serverProperties = {
        server-port = 25565;
        max-players = 32;
        difficulty = "hard";
        motd = "One Heck of a Server";
        simulation-distance = 16;
        view-distance = 32;
        gamemode = "survival";

        online-mode = true; # TODO: Change depending on needs
        # white-list = true; # TODO: Whitelist players
        # enforce-whitelist = true;
        # force-gamemode = true;
      };
      mods = {
        BETTER_FABRIC_CONSOLE = {
          url = "https://cdn.modrinth.com/data/Y8o1j1Sf/versions/3d1g5aTY/better-fabric-console-mc1.21.4-1.2.2.jar";
          sha512 = "aa7ea5e6fad06927462655331985e58d270bf2f6ac31a9c685830e8d4249c6a3de51f2a2e63ddef150432040448926c3238d3bab4722a26733c5e7db64359563";
        };
        C2ME = {
          url = "https://cdn.modrinth.com/data/VSNURh3q/versions/EzvMx6b2/c2me-fabric-mc1.21.4-0.3.1.3.0.jar";
          sha512 = "f944bf4319cfa6fb645d0cbe807b82c74784f44ef7ac75273efa161be4625aa80390ec8cf32a232c0ebce0d0cb23b090979019d93e7550771de56d09d920dd13";
        };
        FABRIC_API = {
          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/bQZpGIz0/fabric-api-0.119.2%2B1.21.4.jar";
          sha512 = "bb8de90d5d1165ecc17a620ec24ce6946f578e1d834ddc49f85c2816a0c3ba954ec37e64f625a2f496d35ac1db85b495f978a402a62bbfcc561795de3098b5c9";
        };
        FERRITE_CORE = {
          url = "https://cdn.modrinth.com/data/uXXizFIs/versions/IPM0JlHd/ferritecore-7.1.1-fabric.jar";
          sha512 = "f41dc9e8b28327a1e29b14667cb42ae5e7e17bcfa4495260f6f851a80d4b08d98a30d5c52b110007ee325f02dac7431e3fad4560c6840af0bf347afad48c5aac";
        };
        KRYPTON = {
          url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/Acz3ttTp/krypton-0.2.8.jar";
          sha512 = "5f8cf96c79bfd4d893f1d70da582e62026bed36af49a7fa7b1e00fb6efb28d9ad6a1eec147020496b4fe38693d33fe6bfcd1eebbd93475612ee44290c2483784";
        };
        LITHIUM = {
          url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/u8pHPXJl/lithium-fabric-0.15.3%2Bmc1.21.4.jar";
          sha512 = "b8b541c0e968571c8972872b342e34b92573bc9210d455dc1349589f30a67a90d930dbfd99b176ab9b110350ceb53e11118378dc13a35e83a9090826627bdac0";
        };
        NOISIUM = {
          url = "https://cdn.modrinth.com/data/KuNKN7d2/versions/9NHdQfkN/noisium-fabric-2.5.0%2Bmc1.21.4.jar";
          sha512 = "3119f9325a9ce13d851d4f6eddabade382222c80296266506a155f8e12f32a195a00a75c40a8d062e4439f5a7ef66f3af9a46f9f3b3cb799f3b66b73ca2edee8";
        };
        TAB_TPS = {
          url = "https://cdn.modrinth.com/data/cUhi3iB2/versions/4ZymMeRM/tabtps-fabric-mc1.21.4-1.3.26.jar";
          sha512 = "d032df38b2e184dc7e4f565534935bef7ce0c72d2f77266407a8b2fecb84db465b563a82f2b7ffb25e082c6cbd47301721634b64b55f4d0c6d1b7d3e7063675a";
        };
        THREAD_TWEAK = {
          url = "https://cdn.modrinth.com/data/vSEH1ERy/versions/IvtlnXcT/threadtweak-fabric-0.1.7%2Bmc1.21.5.jar";
          sha512 = "aec7e39b478d47dc96ba12291fd048ed9253c39d27a0c25b8565b3cef08eb5117b4f6bf2453c3377d2de739de8ba0501c77b291b6f0fc82559f0f30514a9125a";
        };
      };
    };
  };
}

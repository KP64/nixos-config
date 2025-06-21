{
  config,
  invisible,
  rootPath,
  ...
}:
{
  imports = [
    ./disko-config.nix
    ./minecraft.nix
  ];

  facter.reportPath = ./facter.json;

  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      "users/sv/password".neededForUsers = true;
      acme_credentials = { };
      "minecraft.env" = { };
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
      invidious.enable = true;
      redlib.enable = true;
      stirling-pdf.enable = true;
    };

    misc = {
      atuin.enable = true; # TODO: Sign in
      glance = {
        enable = true;
        inherit (invisible.glance) location;
      };
      languagetool.enable = true;
    };

    networking = {
      tor.enable = true;
      traefik.enable = true;
    };

    security = {
      fail2ban.enable = true;
    };
  };
}

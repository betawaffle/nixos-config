_:
{
  imports = [
    ./agenix.nix
  ];

  age.secrets.netbox-secret-key = {
    file = ../secrets/netbox-secret-key.age;
    owner = "netbox";
    group = "netbox";
  };

  services.netbox.enable = true;
  services.netbox.secretKeyFile = "/run/agenix/netbox-secret-key";

  services.caddy.enable = true;
  services.caddy.email = "betawaffle+acme@gmail.com";
  services.caddy.acmeCA = "https://acme-staging-v02.api.letsencrypt.org/directory";
  # services.caddy.user = "netbox";
  services.caddy.group = "netbox";
  services.caddy.virtualHosts."localhost" = {
    extraConfig = ''
      encode gzip zstd
      root * /var/lib/netbox
      @notStatic {
        not path /static/*
      }
      reverse_proxy @notStatic [::1]:8001
      file_server
    '';
  };
}

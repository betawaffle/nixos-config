{ config, ... }:
{
  # Enable the SSH server.
  services.openssh.enable = true;

  # Use socket activation.
  services.openssh.startWhenNeeded = true;

  # Don't open the firewall if not using the regular firewall.
  services.openssh.openFirewall = config.networking.firewall.enable;

  # Store SSH host keys in a different location.
  services.openssh.hostKeys = [
    {
      path = "/var/lib/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
    {
      path = "/var/lib/ssh/ssh_host_rsa_key";
      type = "rsa";
      bits = 4096;
    }
  ];
}

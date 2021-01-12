{ config, ... }:
{
  # Enable the SSH server.
  services.openssh.enable = true;

  # Use socket activation.
  services.openssh.startWhenNeeded = true;

  # Don't open the firewall if not using the regular firewall.
  services.openssh.openFirewall = config.networking.firewall.enable;

  # Public-key auth only.
  services.openssh.challengeResponseAuthentication = false;
  services.openssh.passwordAuthentication = false;
}

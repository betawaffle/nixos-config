{ config, ... }:
{
  # Enable Plex Media Server.
  services.plex.enable = true;

  # Don't open the firewall if not using the regular firewall.
  services.plex.openFirewall = config.networking.firewall.enable;
}

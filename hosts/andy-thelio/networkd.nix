{ lib, ... }:
{
  # Not sure if this is necessary, but since we're using networkd, we don't
  # want it.
  networking.dhcpcd.enable = false;

  # I was told to set this to false. Is that still necessary?
  networking.useDHCP = false;

  # Use systemd-networkd for all our network config.
  networking.useNetworkd = true;

  # Uhh... why is this needed?
  systemd.services.systemd-networkd.requires = lib.mkForce [];

  # Don't wait for network-online?
  systemd.targets.network-online.wantedBy = lib.mkForce [];
}

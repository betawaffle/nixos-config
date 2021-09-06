{ ... }:
{
  # Disable the default firewall, use nftables.
  networking.firewall.enable = false;
  networking.nftables.enable = true;
}

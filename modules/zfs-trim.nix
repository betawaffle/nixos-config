{ lib, ... }:
{
  # Configure automatic TRIM (for SSDs).
  services.zfs.trim.enable = true;
  services.zfs.trim.interval = lib.mkDefault "weekly";
}

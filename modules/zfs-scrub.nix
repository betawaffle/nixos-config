{ lib, ... }:
{
  # Configure automatic scrub.
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = lib.mkDefault "weekly";
}

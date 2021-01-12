{ ... }:
{
  # TODO: Use this, since the docs recommended disabling force import.
  #
  # boot.zfs.forceImportRoot = false;

  # Configure automatic scrub.
  services.zfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  # Configure automatic replication.
  services.zfs.autoReplication = {
    # TODO
  };

  # Configure automatic snapshot.
  services.zfs.autoSnapshot = {
    # TODO
  };

  # Configure automatic TRIM (for SSDs).
  services.zfs.trim = {
    enable = true;
    interval = "weekly";
  };

  # Configure ZFS event daemon.
  services.zfs.zed.settings = {
    # TODO
  };
}

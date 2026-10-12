{ config, lib, ... }:

let
  inherit (lib) head mapAttrs mkAfter mkIf mkOption splitString types;

  cfg = config.common.zfsRoot;

  rootDataset = cfg.datasets."/";

  rootSnapshot = "blank";

  rootPool = head (splitString "/" rootDataset);
in

{
  options.common.zfsRoot = {
    datasets = mkOption {
      type = types.attrsOf types.str;
      description = ''
        A mapping of mountpoints to dataset names, which must be mounted at boot.
      '';
    };
  };

  config = {
    # Erase everything in the root filesystem on boot.
    boot.initrd.postDeviceCommands = mkIf (!config.boot.initrd.systemd.enable) (mkAfter ''
      zfs rollback -r ${rootDataset}@${rootSnapshot}
    '');

    # Same thing for the systemd-based initrd (the default since NixOS 25.11):
    # roll back after the pool is imported, before the root is mounted.
    boot.initrd.systemd.services.zfs-rollback-root = mkIf config.boot.initrd.systemd.enable {
      description = "Roll back ${rootDataset} to @${rootSnapshot}";
      wantedBy = [ "initrd.target" ];
      after = [ "zfs-import-${rootPool}.service" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = "zfs rollback -r ${rootDataset}@${rootSnapshot}";
    };

    boot.supportedFilesystems = [ "zfs" ];

    # Don't force-import the root pool, as the docs recommend. This relies on
    # networking.hostId matching the hostid recorded in the pool.
    boot.zfs.forceImportRoot = false;

    fileSystems = mapAttrs (_: value: { device = value; fsType = "zfs"; }) cfg.datasets;
  };
}

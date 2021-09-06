{ config, lib, pkgs, ... }:

let
  inherit (lib) mapAttrs mkAfter mkOption types;

  cfg = config.common.zfsRoot;

  rootDataset = cfg.datasets."/";

  rootSnapshot = "blank";
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
    boot.initrd.postDeviceCommands = mkAfter ''
      zfs rollback -r ${rootDataset}@${rootSnapshot}
    '';

    boot.supportedFilesystems = [ "zfs" ];

    # TODO: Use this, since the docs recommended disabling force import.
    #
    # boot.zfs.forceImportRoot = false;

    fileSystems = mapAttrs (name: value: { device = value; fsType = "zfs"; }) cfg.datasets;
  };
}

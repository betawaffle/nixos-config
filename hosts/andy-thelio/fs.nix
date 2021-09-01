{ ... }:

let
  # Helpers for filesystem types.
  ext4 = attrs: attrs // { fsType = "ext4"; };
  vfat = attrs: attrs // { fsType = "vfat"; };

  # Helpers for disk identifiers.
  byID        = v: fs: fs { device = "/dev/disk/by-id/${v}"; };
  byLabel     = v: fs: fs { device = "/dev/disk/by-label/${v}"; };
  byPartLabel = v: fs: fs { device = "/dev/disk/by-partlabel/${v}"; };
  byPartUUID  = v: fs: fs { device = "/dev/disk/by-partuuid/${v}"; };
  byPath      = v: fs: fs { device = "/dev/disk/by-path/${v}"; };
  byUUID      = v: fs: fs { device = "/dev/disk/by-uuid/${v}"; };

  # Helpers for zfs datasets in my root pool.
  rpool = path: { fsType = "zfs"; device = "rpool/${path}"; };
in

{
  imports = [
    # Wipe out root filesystem on every boot.
    ./erase-your-darlings.nix

    # Configure ZFS things.
    ./zfs.nix
  ];

  fileSystems = {
    # My root filesystem is on zfs.
    "/" = rpool "system/root";

    # To simplify booting, my efi system partition is vfat.
    "/boot" = byUUID "8EDB-66A5" vfat;

    # Non-root user home directories.
    "/home" = rpool "user/home";
    "/home/betawaffle" = rpool "user/home/betawaffle";

    # Pictures on Mnemosyne.
    "/mnt/pictures" = {
      device = "192.168.0.8:/volume2/Pictures";
      fsType = "nfs";

      options = [
        "ro"
        "soft"
        "bg"
        "x-systemd.automount"
        "noauto"
      ];
    };

    # The nix store and related state.
    "/nix" = rpool "local/nix";

    # Keep persistent state out of root, which is wiped on every boot.
    "/var" = rpool "system/var";
  };

  swapDevices = [
    # No swap necessary.
  ];
}

# Storage layout and backups for moneta.
#
# rpool (2x SATA SSD mirror) holds the OS: / (rolled back every boot), /nix,
# and the small amount of state in rpool/repl (/var, /home). Those SATA links
# have thrown CRC errors since day one, so anything that matters either lives
# on dpool or is replicated there.
{ lib, pkgs, ... }:

let
  # The Framework box's backup key (root's /root/.ssh/moneta_backup.pub there).
  frameworkBackupKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0ykeiwH3aj2dZd7J4iXYRoT5aCWO/ZzQos/EzInBGE root@framework"
  ];
in

{
  # The rpool SSDs (onboard SATA1/SATA2 = ata2/ata3) have logged link resets
  # and UDMA CRC errors on writes since 2021, and the kernel already drops
  # ata3 to 3.0 Gbps after a few resets on most boots. Start both at 3.0 Gbps,
  # which is still faster than these SSDs can sustain.
  boot.kernelParams = [ "libata.force=2:3.0G,3:3.0G" ];

  # Plex's database and metadata live on dpool rather than rpool.
  fileSystems."/var/lib/plex" = {
    device = "dpool/plex";
    fsType = "zfs";

    # Don't drop to emergency mode if dpool can't be imported; Plex just won't
    # start (see RequiresMountsFor below).
    options = [ "nofail" ];
  };

  systemd.services.plex.unitConfig.RequiresMountsFor = [ "/var/lib/plex" ];

  # Snapshot rpool/repl and dpool/plex, and prune the replicas on dpool.
  services.sanoid = {
    enable = true;

    datasets."rpool/repl" = {
      recursive = true;
      hourly = 24;
      daily = 14;
      monthly = 3;
    };

    datasets."dpool/plex" = {
      hourly = 24;
      daily = 30;
      monthly = 6;
    };

    # Replicas: never snapshot them directly, only prune what syncoid sends.
    datasets."dpool/backups/moneta/repl" = {
      recursive = true;
      autosnap = false;
      autoprune = true;
      hourly = 48;
      daily = 60;
      monthly = 12;
    };

    # Nightly rsync of the Framework box; one snapshot a day is enough.
    datasets."dpool/backups/framework" = {
      autosnap = true;
      autoprune = true;
      hourly = 0;
      daily = 14;
      weekly = 8;
      monthly = 12;
    };

    datasets."dpool/lab" = {
      autosnap = true;
      autoprune = true;
      hourly = 24;
      daily = 7;
    };
  };

  # Backups of the Framework box (192.168.1.79), pushed nightly over SSH with
  # rsync --fake-super, so owners and modes are kept in xattrs.
  #
  # Created by hand:
  #
  #   zfs create -o quota=200G -o xattr=sa dpool/backups/framework
  #
  # It inherits compression=zstd and mounts at /srv/backups/framework.
  #
  # The box must push with -M--fake-super so the flag reaches moneta's side;
  # a plain --fake-super only affects the sending side, and the unprivileged
  # receiver would silently drop owners, groups and device files.
  users.users.framework-backup = {
    isSystemUser = true;
    group = "framework-backup";

    # Pinned so the backup tree's ownership survives losing /var/lib/nixos.
    uid = 900;

    # sshd runs the forced command through the login shell.
    useDefaultShell = true;

    # Only rsync, and only inside the backup dataset.
    openssh.authorizedKeys.keys = map
      (key: ''command="${pkgs.rrsync}/bin/rrsync /srv/backups/framework",restrict ${key}'')
      frameworkBackupKeys;
  };

  # Pinned to match the uid above.
  users.groups.framework-backup.gid = 900;

  warnings = lib.optional (frameworkBackupKeys == [ ])
    "framework-backup has no authorized key yet; add the Framework box's /root/.ssh/moneta_backup.pub to frameworkBackupKeys in hosts/moneta/storage.nix.";

  # Shared folder for the Framework box (and later the Mac), exported over NFS
  # to the LAN. Every client is squashed to 1000:1000, which owns the tree.
  #
  # Created by hand:
  #
  #   zfs create -o recordsize=1M -o quota=1T dpool/lab
  #   zfs set sharenfs='rw=@192.168.0.0/23,insecure,all_squash,anonuid=1000,anongid=1000,crossmnt' dpool/lab
  #
  # It inherits compression=lz4 and mounts at /srv/lab. "insecure" lets macOS
  # mount it from an unprivileged port.
  systemd.tmpfiles.rules = [
    # "z" only fixes up ownership and mode; it won't create the directory if
    # the dataset isn't mounted.
    "z /srv/backups/framework 0750 framework-backup framework-backup -"
    "z /srv/lab 0755 1000 1000 -"
  ];

  # Replicate rpool/repl (/var, /home) to dpool using sanoid's snapshots.
  # Created by hand: dpool/backups/moneta (canmount=off, readonly=on) and
  # dpool/backups/moneta/repl (canmount=off, mountpoint=none), so the replicas
  # are never mounted and can't diverge from what syncoid sends. rpool/repl
  # itself holds no data, so only its children are sent.
  services.syncoid = {
    enable = true;
    interval = "hourly";
    commonArgs = [ "--no-sync-snap" ];

    commands."rpool/repl" = {
      target = "dpool/backups/moneta/repl";
      recursive = true;
      extraArgs = [ "--skip-parent" ];
    };
  };

  # Keep a copy of the ESP on the second rpool SSD so the box can still boot if
  # the first one dies. The firmware falls back to EFI/BOOT/BOOTX64.EFI on any
  # disk, which systemd-boot installs.
  fileSystems."/boot-mirror" = {
    device = "/dev/disk/by-uuid/7E97-4995";
    fsType = "vfat";
    options = [ "nofail" "umask=0077" ];
  };

  boot.loader.systemd-boot.extraInstallCommands = ''
    if ${pkgs.util-linux}/bin/mountpoint -q /boot-mirror; then
      ${pkgs.rsync}/bin/rsync -rt --modify-window=2 --delete /boot/ /boot-mirror/
    else
      echo "warning: /boot-mirror is not mounted, ESP not mirrored" >&2
    fi
  '';

  # The BMC's virtual keyboard/mouse (and its hub) don't wake up from USB
  # autosuspend, so iKVM input is silently dropped. Keep them powered.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0557", ATTR{idProduct}=="2419", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0557", ATTR{idProduct}=="7000", ATTR{power/control}="on"
  '';

  # powertop --auto-tune (modules/powertop.nix) runs after udev at boot and
  # puts every USB device back into autosuspend, so re-apply it afterwards.
  systemd.services.bmc-usb-no-autosuspend = {
    description = "Keep the BMC's virtual USB keyboard out of autosuspend";
    after = [ "powertop.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      for d in /sys/bus/usb/devices/*; do
        if [ "$(cat "$d/idVendor" 2>/dev/null)" = 0557 ]; then
          echo on > "$d/power/control"
        fi
      done
    '';
  };
}

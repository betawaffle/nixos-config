# Storage layout and backups for moneta.
#
# rpool (2x SATA SSD mirror) holds the OS: / (rolled back every boot), /nix,
# and the small amount of state in rpool/repl (/var, /home). Those SATA links
# have thrown CRC errors since day one, so anything that matters either lives
# on dpool or is replicated there.
{ pkgs, ... }:
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
  };

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
}

# moneta recovery runbook

moneta is the home server: Supermicro H11SSL-i, AMD EPYC 7281, 128 GB ECC.
Everything it runs is defined by `nixosConfigurations.moneta` in this repo.

## Storage at a glance

| Pool  | Disks | Holds |
|-------|-------|-------|
| `rpool` | 2× 250 GB SATA SSD mirror (onboard SATA1/SATA2) | the OS |
| `dpool` | 3× 2-way mirrors of 18 TB HDDs + 2 TB SSD special mirror (LSI HBA) | media, Plex, backups |

rpool datasets (all `mountpoint=legacy`, mounted via `common.zfsRoot.datasets`):

| Dataset | Mount | Notes |
|---|---|---|
| `rpool/drop/root` | `/` | rolled back to `@blank` on every boot |
| `rpool/keep/nix` | `/nix` | rebuildable, not backed up |
| `rpool/repl/var` | `/var` | replicated to dpool |
| `rpool/repl/home` | `/home` | replicated to dpool |
| `rpool/repl/home/root` | `/root` | replicated to dpool |

Things that live on dpool instead of rpool:

- `dpool/plex` → `/var/lib/plex` (Plex database and metadata).
- `dpool/backups/moneta/repl` ← hourly `syncoid` of `rpool/repl` (sanoid
  snapshots: 48 hourly, 60 daily, 12 monthly).

Each rpool SSD has its own ESP. `/boot` is the one on
`wwn-0x5888914103be8aa1` (UUID `7E30-68F1`), and `/boot-mirror` is the one on
`wwn-0x5888914103be8a8f` (UUID `7E97-4995`). The second ESP is rsynced after
every bootloader install, so either disk can boot on its own.

The rpool SATA links have logged CRC errors and link resets since 2021. ZFS
has always repaired them. A DEGRADED rpool with no data errors is the normal
state, not an emergency.

## Getting a console

- **IPMI web UI:** https://192.168.2.11 (static, VLAN 2), user `ADMIN`.
  Three wrong passwords lock the account for 5 minutes.
- **Remote Control → iKVM/HTML5** shows the screen. Use Virtual Media to
  attach an ISO.
- There are no console logins: every account's password is locked, and
  access is SSH-key only. Use the console to pick a boot entry or watch boot.
- Serial-over-LAN:
  `ipmitool -I lanplus -H 192.168.2.11 -U ADMIN -a sol activate`
  (exit with `~.`).

## A new generation is broken

- In the systemd-boot menu (5 s timeout), pick the previous generation.
- Once booted, run `nixos-rebuild switch --rollback`, or switch to a known-good
  branch with
  `nixos-rebuild switch --flake github:betawaffle/nixos-config/<branch>#moneta`.
- To try a generation once without making it the default:
  `bootctl set-oneshot <entry>.conf` (see `bootctl list`).

## rpool is lost (both SSDs dead, or pool unimportable)

Media, Plex and the backups are all on dpool, so this is a reinstall plus a
restore.

1. **Replace the SSDs** and note their `/dev/disk/by-id/wwn-…` names. The
   steps below call them `$A` and `$B`.

2. **Boot the NixOS installer.** Use a USB stick, or attach a current
   minimal ISO through the IPMI's Virtual Media. Then get a root shell:
   `sudo -i`.

3. **Partition both SSDs** the same way the originals were:

   ```sh
   for d in $A $B; do
     sgdisk --zap-all /dev/disk/by-id/$d
     sgdisk -a1 -n1:48:2047 -t1:EF02 /dev/disk/by-id/$d   # 1000 KiB BIOS boot (unused)
     sgdisk     -n2:0:+512M -t2:EF00 /dev/disk/by-id/$d   # ESP
     sgdisk     -n3:0:+1G   -t3:BF01 /dev/disk/by-id/$d   # spare (unused)
     sgdisk     -n4:0:0     -t4:BF01 /dev/disk/by-id/$d   # rpool
     mkfs.fat -F 32 /dev/disk/by-id/$d-part2
   done
   blkid /dev/disk/by-id/$A-part2 /dev/disk/by-id/$B-part2   # note the new UUIDs
   ```

4. **Recreate rpool.** These are the original 2021 commands:

   ```sh
   zpool create -o ashift=12 \
     -O acltype=posixacl -O canmount=off -O compression=lz4 -O dnodesize=auto \
     -O normalization=formD -O relatime=on -O xattr=sa -O mountpoint=none \
     rpool mirror /dev/disk/by-id/$A-part4 /dev/disk/by-id/$B-part4

   zfs create -o canmount=off -o mountpoint=none -o sync=disabled rpool/drop
   zfs create -o canmount=off -o mountpoint=none rpool/keep
   zfs create -o mountpoint=legacy rpool/drop/root
   zfs snapshot rpool/drop/root@blank
   zfs create -o mountpoint=legacy rpool/keep/nix
   ```

5. **Restore rpool/repl from dpool:**

   ```sh
   zpool import -N -f dpool
   zfs list -t snapshot -o name -s creation -r dpool/backups/moneta/repl | tail
   snap=autosnap_…   # the newest snapshot of dpool/backups/moneta/repl itself
   zfs send -R dpool/backups/moneta/repl@$snap | zfs recv -u rpool/repl
   zfs set canmount=off rpool/repl
   zfs set mountpoint=none rpool/repl
   for ds in var home home/root; do
     zfs set mountpoint=legacy rpool/repl/$ds
     zfs inherit readonly rpool/repl/$ds
   done
   ```

6. **Mount everything** under `/mnt` the way the config expects:

   ```sh
   mount -t zfs rpool/drop/root /mnt
   mkdir -p /mnt/{nix,var,home,root,boot,boot-mirror}
   mount -t zfs rpool/keep/nix       /mnt/nix
   mount -t zfs rpool/repl/var       /mnt/var
   mount -t zfs rpool/repl/home      /mnt/home
   mount -t zfs rpool/repl/home/root /mnt/root
   mount /dev/disk/by-id/$A-part2 /mnt/boot
   mount /dev/disk/by-id/$B-part2 /mnt/boot-mirror
   ```

7. **Point the config at the new ESPs.** Set `common.espUUID` in
   `hosts/moneta/configuration.nix` to `$A-part2`'s UUID. Set the
   `/boot-mirror` device in `hosts/moneta/storage.nix` to `$B-part2`'s UUID.
   Commit and push (from another machine, or from the installer with
   `nix-shell -p git`).

8. **Install:**

   ```sh
   nixos-install --root /mnt --no-root-passwd \
     --flake github:betawaffle/nixos-config/<branch>#moneta
   ```

9. **Clean up and reboot:**

   ```sh
   umount -R /mnt
   zpool export rpool
   zpool export dpool
   ```

   Detach the virtual media and reboot. The SSH host keys come back with
   `/var/lib/ssh`, so clients won't see a changed key. Plex's data was never
   on rpool.

## dpool is lost

The media datasets have no second copy. Recover them from wherever the
originals came from.

- `/var` and `/home` still have rpool's own sanoid snapshots
  (`zfs list -t snapshot -r rpool/repl`).
- Plex's database is gone along with dpool. The pre-26.11 copy in
  `dpool/backups/moneta-var-pre-26.11` would be gone too.

## Known quirks

- **iKVM keyboard:** the BMC's virtual USB keyboard drops input under USB
  autosuspend. `hosts/moneta/storage.nix` has a udev rule for it. If input
  dies anyway, run
  `echo on > /sys/bus/usb/devices/<hub-and-port>/power/control` for vendor
  `0557`.
- **IRQ 9:** the kernel logs `irq 9: nobody cared` (ACPI) and disables it.
  After that, a short power-button press may do nothing. Hold the button, or
  power-cycle from the IPMI.
- **`forceImportRoot`:** still `true`. Flip it to `false` once 26.11 has
  proven stable.

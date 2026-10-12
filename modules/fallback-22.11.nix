# Keep the pre-upgrade NixOS 22.11 system (generation 17) bootable from the
# systemd-boot menu while 26.11 settles in.
#
# The 26.11 bootloader builder skips generations without a boot.json (anything
# built before ~23.05) and deletes their kernels from the ESP, so the entry has
# to be installed explicitly. The store paths below are kept alive by the
# /nix/var/nix/gcroots/keep-gen17 GC root on moneta.
#
# TODO: remove after 2026-11-15 (pre-26.11 fallback), along with the
# keep-gen17 GC root.
_:

let
  system = "/nix/store/dxhzy8r5wl18syvsl1np26pnzdcyc83y-nixos-system-moneta-22.11.20220807.4bdf416";
  kernel = "/nix/store/g84svn2snjpmz1n2nwyi6cy2vy43hc6q-linux-5.15.59/bzImage";
  initrd = "/nix/store/dav8x6p6d8z94v2qvv927q99nnzdwn1g-initrd-linux-5.15.59/initrd";
in

{
  boot.loader.systemd-boot.extraFiles = {
    "EFI/nixos/fallback-22.11-linux.efi" = kernel;
    "EFI/nixos/fallback-22.11-initrd.efi" = initrd;
  };

  boot.loader.systemd-boot.extraEntries."nixos-fallback-22.11.conf" = ''
    title NixOS 22.11 (generation 17, pre-upgrade fallback)
    version Generation 17 NixOS 22.11.20220807.4bdf416 (Linux 5.15.59)
    linux /EFI/nixos/fallback-22.11-linux.efi
    initrd /EFI/nixos/fallback-22.11-initrd.efi
    options init=${system}/init loglevel=4
    sort-key nixos-zz-fallback
  '';
}

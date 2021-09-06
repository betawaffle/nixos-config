{ config, lib, pkgs, sshPublicKeys, ... }:
{
  imports = [
    ../../modules/apc-ups.nix
    ../../modules/common.nix
    ../../modules/cpu/amd-epyc-7281.nix
    ../../modules/efi.nix
    ../../modules/nfs-server.nix
    ../../modules/nix.nix
    ../../modules/nixpkgs.nix
    ../../modules/plex-server.nix
    ../../modules/smart.nix
    ../../modules/ssh-server.nix
    ../../modules/zfs-root.nix
    ../../modules/zfs-scrub.nix
    ../../modules/zfs-trim.nix
  ];

  boot.initrd.availableKernelModules = [ "mpt3sas" ];

  common.espUUID = "7E30-68F1";

  common.zfsRoot.datasets = {
    # Needed for boot.
    "/"    = "rpool/drop/root";
    "/nix" = "rpool/keep/nix";
    "/var" = "rpool/repl/var";

    # Currently mountpoint=legacy, but that may not be necessary.
    "/home" = "rpool/repl/home";
    "/root" = "rpool/repl/home/root";
  };

  environment.systemPackages = with pkgs; [
    parted
    gptfdisk
    ddrescue

    # Hardware-related tools.
    sdparm
    hdparm
    usbutils
  ];

  environment.etc."zfs/vdev_id.conf".text = ''
    alias SATA0   /dev/disk/by-path/pci-0000:42:00.2-ata-1
    alias SATA1   /dev/disk/by-path/pci-0000:42:00.2-ata-2
    alias SATA2   /dev/disk/by-path/pci-0000:42:00.2-ata-3
    alias SATA3   /dev/disk/by-path/pci-0000:42:00.2-ata-4

    alias 1-1     /dev/disk/by-path/pci-0000:61:00.0-sas-phy2-lun-0
    alias 1-2     /dev/disk/by-path/pci-0000:61:00.0-sas-phy3-lun-0
    alias 1-3     /dev/disk/by-path/pci-0000:61:00.0-sas-phy1-lun-0
    alias 1-4     /dev/disk/by-path/pci-0000:61:00.0-sas-phy0-lun-0

    alias 1-5     /dev/disk/by-path/pci-0000:61:00.0-sas-phy6-lun-0
    alias 1-6     /dev/disk/by-path/pci-0000:61:00.0-sas-phy7-lun-0
    alias 1-7     /dev/disk/by-path/pci-0000:61:00.0-sas-phy5-lun-0
    alias 1-8     /dev/disk/by-path/pci-0000:61:00.0-sas-phy4-lun-0

    alias 1-9     /dev/disk/by-path/pci-0000:61:00.0-sas-phy18-lun-0
    alias 1-10    /dev/disk/by-path/pci-0000:61:00.0-sas-phy19-lun-0
    alias 1-11    /dev/disk/by-path/pci-0000:61:00.0-sas-phy17-lun-0
    alias 1-12    /dev/disk/by-path/pci-0000:61:00.0-sas-phy16-lun-0

    alias 1-13    /dev/disk/by-path/pci-0000:61:00.0-sas-phy22-lun-0
    alias 1-14    /dev/disk/by-path/pci-0000:61:00.0-sas-phy23-lun-0
    alias 1-15    /dev/disk/by-path/pci-0000:61:00.0-sas-phy21-lun-0

    alias 2-1     /dev/disk/by-path/pci-0000:23:00.0-sas-phy2-lun-0
    alias 2-2     /dev/disk/by-path/pci-0000:23:00.0-sas-phy3-lun-0
    alias 2-3     /dev/disk/by-path/pci-0000:23:00.0-sas-phy1-lun-0
    alias 2-4     /dev/disk/by-path/pci-0000:23:00.0-sas-phy0-lun-0

    alias 2-5     /dev/disk/by-path/pci-0000:23:00.0-sas-phy18-lun-0
    alias 2-6     /dev/disk/by-path/pci-0000:23:00.0-sas-phy19-lun-0
    alias 2-7     /dev/disk/by-path/pci-0000:23:00.0-sas-phy17-lun-0
    alias 2-8     /dev/disk/by-path/pci-0000:23:00.0-sas-phy16-lun-0

    alias 2-9     /dev/disk/by-path/pci-0000:23:00.0-sas-phy6-lun-0
    alias 2-10    /dev/disk/by-path/pci-0000:23:00.0-sas-phy7-lun-0
    alias 2-11    /dev/disk/by-path/pci-0000:23:00.0-sas-phy5-lun-0
    alias 2-12    /dev/disk/by-path/pci-0000:23:00.0-sas-phy4-lun-0

    alias 2-13    /dev/disk/by-path/pci-0000:23:00.0-sas-phy22-lun-0
    alias 2-14    /dev/disk/by-path/pci-0000:23:00.0-sas-phy23-lun-0
    alias 2-15    /dev/disk/by-path/pci-0000:23:00.0-sas-phy21-lun-0
  '';

  # Disable the firewall.
  networking.firewall.enable = false;

  # Needed for zfs. It's just 8 random hex digits.
  networking.hostId = "deadbeef";

  # DHCP on interfaces.
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.eno2.useDHCP = true;

  # Before changing this value read the documentation for this option.
  system.stateVersion = "21.11";

  # Completely declarative users.
  users.mutableUsers = false;

  # Add ssh key(s) for root.
  users.users.root.openssh.authorizedKeys.keys = [
    sshPublicKeys.andy-mac-pro
    sshPublicKeys.andy-thelio
  ];
}

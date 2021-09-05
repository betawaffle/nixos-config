{ config, flakes, lib, pkgs, ... }:
{
  imports = [
    # (flakes.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  boot.kernelModules = [ "kvm-amd" ];
  boot.supportedFilesystems = [ "zfs" ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "mpt3sas" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/drop/root@blank
  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.zfs.devNodes = "/dev/disk/by-vdev";

  environment.systemPackages = with pkgs; [
    efibootmgr
    efivar
    parted
    gptfdisk
    ddrescue

    # Hardware-related tools.
    sdparm
    hdparm
    smartmontools # for diagnosing hard disks
    pciutils
    usbutils

    # Some compression/archiver tools.
    unzip
    zip
  ];

  # 1-1 = ZR52BWBP -- 2026-10-08
  # 1-2 = ZR52CKKE -- 2026-10-08
  # 1-3 = ZR52BWAC -- 2026-10-08
  # 2-1 = ZR52BWCQ -- 2026-10-08
  # 2-2 = ZR52CKY8 -- 2026-10-08
  # 2-3 = ZR52CKWC -- 2026-10-08

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

  fileSystems."/" = {
    device = "rpool/drop/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7E30-68F1";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "rpool/repl/home";
    fsType = "zfs";
  };

  fileSystems."/root" = {
    device = "rpool/repl/home/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/keep/nix";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "rpool/repl/var";
    fsType = "zfs";
  };


  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Needed for zfs. It's just 8 random hex digits.
  networking.hostId = "deadbeef";

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.eno2.useDHCP = true;

  # Allow installing software with non-free licenses.
  nixpkgs.config.allowUnfree = true;

  # UPS
  services.apcupsd = {
    enable = true;
  };

  # SSH
  services.openssh = {
    # Enable the SSH server.
    enable = true;

    # Use socket activation.
    startWhenNeeded = true;

    # Don't open the firewall if not using the regular firewall.
    openFirewall = config.networking.firewall.enable;

    # Store SSH host keys in a persistent location.
    hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/var/lib/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

  # Plex
  services.plex = {
    enable = true;

    openFirewall = config.networking.firewall.enable;
  };

  # S.M.A.R.T.
  services.smartd = {
    enable = true;
  };

  # This value determines the NixOS release from which the default settings for
  # stateful data, like file locations and database versions on your system
  # were taken.
  #
  # It's perfectly fine (and recommended) to leave this value at the release
  # version of the first install of this system.
  #
  # Before changing this value read the documentation for this option.
  system.stateVersion = "21.11";

  # systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];

  # I'm in the eastern timezone.
  time.timeZone = "America/New_York";

  # Add my ssh key(s) for root.
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBz210SJVEreBoHAp7abf5AV9vvRfbOURfCXnQwV/i6rsDmmNR1GSGyjoxn4CzwSK1Iv6spjDnaSDupypxeQmU2M1rF8Cxe/oiVaGhGvaAL0obKJp1ZjarPe8RQvILXvGtemwjyjgw+SZ+nXgXAoKxlD6WqMVg2J2H6FVyzEOq+Cffmw2Ipwaoyf3/Jw4hhOvYzB0Nrai25XVEajiBl/favaeqVTEYdkkePf1EIlYVbDbi8DC1/e4ADAajM/4i6H1z/iILHmNBkxXB5QteIXVyaF1powgVhCQF/3hC7VkFV8lCVZ1c52aSHqU0uQgJqJ7RL6LIU+44Zr9zeTE366WL betawaffle@gmail.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN95WKGilabVF8xg9dthK/TKqZNdoIbUBD8XRyRADgnH betawaffle+thelio@gmail.com"
  ];
}

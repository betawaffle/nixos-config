{ config, flakes, lib, pkgs, ... }:
{
  imports = [
    # (flakes.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  boot.extraModulePackages = [];
  boot.kernelModules = [ "kvm-amd" ];
  boot.supportedFilesystems = [ "zfs" ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "mpt3sas" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [];
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/drop/root@blank
  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # Enable the SSH server.
  services.openssh.enable = true;

  # Use socket activation.
  services.openssh.startWhenNeeded = true;

  # Don't open the firewall if not using the regular firewall.
  services.openssh.openFirewall = config.networking.firewall.enable;

  # Store SSH host keys in a persistent location.
  services.openssh.hostKeys = [
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

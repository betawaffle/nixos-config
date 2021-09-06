{ lib, pkgs, ... }:
{
  # Kernel modules that might be needed by the initrd.
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];

  # Install things for all users.
  environment.systemPackages = with pkgs; [
    curl
    file
    htop
    iotop
    jq
    lsof
    pciutils
    ripgrep
    tcpdump
    unzip
    wget
    wireguard
    wireguard-tools
    zip
  ];

  # TODO: Probably not needed. Check to see if we can remove this.
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Top-level DHCP is deprecated.
  networking.useDHCP = false;

  # Less (the alternative to more)
  programs.less.enable = true;

  # Matt's Traceroute
  programs.mtr.enable = true;

  # We're in the eastern timezone.
  time.timeZone = "America/New_York";

  # Completely declarative users.
  users.mutableUsers = false;
}

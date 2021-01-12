{ lib, ... }:

let
  inherit (lib) listToAttrs;

  mapToAttrs = f: list: listToAttrs (map f list);
in

{
  # TODO: Figure out a better place for all of these.

  # Kernel modules that might be needed by the initrd.
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];

  # Kernel runtime options to set during boot.
  boot.kernel.sysctl = {
    # "net.ipv4.ip_forward" = true;
    # "net.ipv4.conf.all.log_martians" = true;
    # "net.ipv6.conf.all.forwarding" = true;
  };

  # Disable these unneeded pam services.
  environment.etc = mapToAttrs (k: { name = "pam.d/${k}"; value.enable = false; }) [
    "i3lock"
    "i3lock-color"
    "vlock"
    "xlock"
    "xscreensaver"
  ];

  # Not sure if this should be enabled or not, but it was enabled previously.
  hardware.enableRedistributableFirmware = true;

  # Set up the user dbus socket by default.
  systemd.user.sockets.dbus.wantedBy = [ "sockets.target" ];
}

{ ... }:
{
  # Allow modifying EFI boot variables.
  boot.loader.efi.canTouchEfiVariables = true;

  # More console output?
  boot.loader.systemd-boot.consoleMode = "max";

  # Use systemd-boot, rather than GRUB.
  boot.loader.systemd-boot.enable = true;

  # Speed up booting slightly by not waiting at the menu.
  boot.loader.timeout = 1;
}

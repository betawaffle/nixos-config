{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;

  espUUID = config.common.espUUID;
in

{
  options.common.espUUID = mkOption {
    type = types.str;
    description = ''
      UUID of the EFI system partition.
    '';
  };

  config = {
    # Allow modifying EFI boot variables.
    boot.loader.efi.canTouchEfiVariables = true;

    # Use systemd-boot, rather than GRUB.
    boot.loader.systemd-boot.enable = true;

    # Some EFI-related tools.
    environment.systemPackages = with pkgs; [
      efibootmgr
      efivar
    ];

    # EFI system partition (ESP) is vfat.
    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/${espUUID}";
      fsType = "vfat";
    };
  };
}

{ pkgs, ... }:
{
  # Use the latest linux kernel I can.
  boot.kernelPackages = pkgs.linuxPackages_latest;
}

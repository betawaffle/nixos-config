{ config, pkgs, ... }:
{
  # Use the latest linux kernel I can.
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with config.boot.kernelPackages; [
    bpftrace
  ];
}

{ config, pkgs, ... }:
{
  environment.systemPackages = [
    config.boot.kernelPackages.bpftrace
    pkgs.bpftool
  ];

  # BPF Compiler Collection
  programs.bcc.enable = true;
}

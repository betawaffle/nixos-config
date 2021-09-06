{ pkgs, ... }:
{
  boot.initrd.availableKernelModules = [ "nvme" ];

  environment.systemPackages = with pkgs; [
    nvme-cli
  ];
}

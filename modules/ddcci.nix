# DCC/CI
#
# For brightness control.

{ config, pkgs, ... }:
{
  # boot.extraModprobeConfig = ''
  #   options ddcci
  # '';

  boot.extraModulePackages = with config.boot.kernelPackages; [
    ddcci-driver
  ];

  # boot.kernelModules = [ "ddcci" "ddcci_backlight" ];

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}

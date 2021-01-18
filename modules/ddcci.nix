# DCC/CI
#
# For brightness control.

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.features.ddcci;
in

{
  options.features.ddcci = {
    enable = mkEnableOption "DCC/CI";
  };

  config = mkIf cfg.enable {
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
  };
}

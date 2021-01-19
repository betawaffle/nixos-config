# Tools for Configuring Logitech G600

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.features.g600;
in

{
  options.features.g600 = {
    enable = mkEnableOption "Logitech G600";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      piper
    ];

    services.ratbagd.enable = true;
  };
}

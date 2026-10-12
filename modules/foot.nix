{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.services.foot;
in

{
  options.services.foot = {
    enable = mkEnableOption "foot";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      foot
    ];

    systemd.user.services.foot = {
      description = "Foot terminal server";
      documentation = [ "man:foot(1)" ];
      requires = [ "foot.socket" ];

      unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";

      serviceConfig.ExecStart = "${pkgs.foot}/bin/foot --server=0";
      serviceConfig.NonBlocking = true;
      serviceConfig.StandardInput = "socket";

      wantedBy = [ "graphical-session.target" ];
    };

    systemd.user.sockets.foot = {
      listenStreams = [ "%t/foot.sock" ];

      wantedBy = [ "graphical-session.target" ];
    };
  };
}

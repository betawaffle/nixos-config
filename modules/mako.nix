{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.services.mako;
in

{
  options.services.mako = {
    enable = mkEnableOption "mako";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mako
    ];

    systemd.user.services.mako = {
      description = "Lightweight Wayland notification daemon";
      documentation = [ "man:mako(1)" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";

      serviceConfig.Type = "dbus";
      serviceConfig.BusName = "org.freedesktop.Notifications";
      serviceConfig.ExecStart = "${pkgs.mako}/bin/mako";
      serviceConfig.ExecReload = "${pkgs.mako}/bin/makoctl reload";
      # serviceConfig.Slice = "session.slice";

      wantedBy = [ "graphical-session.target" ];
    };
  };
}

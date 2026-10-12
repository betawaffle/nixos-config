{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wezterm-updated
  ];

  # systemd.user.services.wezterm-mux-server = {
  #   # partOf   = [ "graphical-session.target" ];
  #   # after    = [ "graphical-session.target" ];
  #   wantedBy = [ "default.target" ];
  #
  #   serviceConfig.ExecStart = "${pkgs.wezterm}/bin/wezterm-mux-server";
  # };
}

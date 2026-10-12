{ pkgs, ... }:
{
  environment.sessionVariables = {
    # XDG_CURRENT_DESKTOP = "sway";
  };

  programs.sway.enable = true;
  programs.sway.wrapperFeatures.gtk = true;

  # systemd.user.targets.sway-session = {
  #   description = "Sway compositor session";
  #   documentation = [ "man:systemd.special(7)" ];
  #   bindsTo = [ "graphical-session.target" ];
  #   wants = [ "graphical-session-pre.target" ];
  #   after = [ "graphical-session-pre.target" ];
  # };

  xdg.portal.wlr.enable = true;
}

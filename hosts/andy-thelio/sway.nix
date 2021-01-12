{ lib, pkgs, ... }:
{
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
  };

  environment.systemPackages = with pkgs; [
    i3status # replace this?
    libinput
    mako
    sway-unwrapped
    swaybg
    swayidle
    swaylock
    wl-clipboard
    xwayland

    # bemenu dmenu waybar
  ];

  hardware.opengl.enable = lib.mkDefault true;

  programs.dconf.enable = lib.mkDefault true;

  security.pam.services.swaylock = {};
}

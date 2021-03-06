{ pkgs, ... }:
{
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
  };

  programs.sway.enable = true;

  programs.sway.extraPackages = with pkgs; [
    bemenu
    grim
    i3status # replace this?
    # i3status-rust
    libinput
    libnotify
    mako
    nwg-launchers
    slurp
    swaybg
    swayidle
    swaylock
    wf-recorder
    wl-clipboard

    # bemenu dmenu waybar
  ];

  services.pipewire.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-wlr
  ];
}

{ pkgs, ... }:
{
  imports = [
    ./sway.nix
  ];

  environment.systemPackages = with pkgs; [
    foot
    grim
    libinput
    libnotify
    #mako
    slurp
    swaybg
    swayidle
    swaylock
    waybar
    wev
    wf-recorder
    wl-clipboard
    wlopm
    yambar

    # bemenu
    # cage
    # i3status # replace this?
    # i3status-rust
    # nwg-launchers
  ];

  # systemd.user.targets."wayland-session@" = {
  #   description = "Wayland compositor session on WAYLAND_DISPLAY=%i";
  #   documentation = [ "man:systemd.special" ];
  #   bindsTo = [ "graphical-session.target" ];
  #   wants = [ "graphical-session-pre.target" ];
  #   after = [ "graphical-session-pre.target" ];
  # };
}

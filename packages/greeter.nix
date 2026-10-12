{ writeShellScript
, river
, greetd
, dbus
, swayidle
, wlopm
}:

let
  displays-off = writeShellScript "displays-off" ''
    exec ${wlopm}/bin/wlopm --off DP-1
  '';

  displays-on = writeShellScript "displays-on" ''
    exec ${wlopm}/bin/wlopm --on DP-1
  '';

  greeter-idle = writeShellScript "greeter-idle" ''
    exec ${swayidle}/bin/swayidle -d -w idlehint 15 timeout 60 ${displays-off} resume ${displays-on}
  '';

  greeter-config = writeShellScript "greeter-config" ''
    export GTK_THEME=Adwaita:dark

    export XDG_SESSION_CLASS=greeter
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=river

    export XDG_CURRENT_DESKTOP=river

    ${dbus}/bin/dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY WAYLAND_DISPLAY

    ${river}/bin/riverctl set-cursor-warp disabled
    ${river}/bin/riverctl set-repeat 50 250
    ${river}/bin/riverctl background-color 0x282828

    ${river}/bin/riverctl spawn ${greeter-idle}

    exec systemd-cat --identifier=gtkgreet ${greetd.gtkgreet}/bin/gtkgreet -l
  '';

  greeter = writeShellScript "greeter" ''
    exec systemd-cat --identifier=greeter ${river}/bin/river -c ${greeter-config}
  '';
in
  greeter

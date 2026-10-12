{ writeShellScriptBin
, sway
, systemd
}:

writeShellScriptBin "start-sway" ''
  export CLUTTER_BACKEND=wayland
  export ECORE_EVAS_ENGINE=wayland-egl
  export ELM_ENGINE=wayland_egl
  export MOZ_ENABLE_WAYLAND=1
  export NO_AT_BRIDGE=1
  export QT_QPA_PLATFORM=wayland-egl
  export SDL_VIDEODRIVER=wayland
  export _JAVA_AWT_WM_NONREPARENTING=1

  export XDG_SESSION_TYPE=wayland

  export XDG_SESSION_DESKTOP=sway
  export XDG_CURRENT_DESKTOP=sway

  exec ${systemd}/bin/systemd-cat --identifier=sway ${sway}/bin/sway "$@"
''

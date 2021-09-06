{ lib, ... }:

let
  inherit (lib) listToAttrs;

  mapToAttrs = f: list: listToAttrs (map f list);
in

{
  # Disable these unneeded pam services.
  environment.etc = mapToAttrs (k: { name = "pam.d/${k}"; value.enable = false; }) [
    "i3lock"
    "i3lock-color"
    "vlock"
    "xlock"
    "xscreensaver"
  ];
}

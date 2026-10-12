{ stdenv
, wayland
, wayland-protocols
, wayland-scanner
, zig
, wlopm
}:

stdenv.mkDerivation {
  pname = "wlopm";
  version = wlopm.rev;
  src = wlopm;

  nativeBuildInputs = [
    wayland
    wayland-protocols
    wayland-scanner
    zig
  ];

  makeFlags = [ "PREFIX=$(out)" ];
}

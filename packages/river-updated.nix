{ lib
, stdenv
, zig
, wayland
, pkg-config
, scdoc
, xwayland
, wayland-protocols
, wlroots
, libxkbcommon
, pixman
, udev
, libevdev
, libinput
, libGL
, libX11
, xwaylandSupport ? true
# flake inputs
, src
, zig-pixman
, zig-wayland
, zig-wlroots
, zig-xkbcommon
}:

stdenv.mkDerivation rec {
  pname = "river";
  version = src.rev or "dirty";

  inherit src;

  postUnpack = ''
    rmdir source/deps/zig-pixman
    ln -Ts ${zig-pixman} source/deps/zig-pixman

    rmdir source/deps/zig-wayland
    ln -Ts ${zig-wayland} source/deps/zig-wayland

    rmdir source/deps/zig-wlroots
    ln -Ts ${zig-wlroots} source/deps/zig-wlroots

    rmdir source/deps/zig-xkbcommon
    ln -Ts ${zig-xkbcommon} source/deps/zig-xkbcommon
  '';

  nativeBuildInputs = [ zig wayland xwayland scdoc pkg-config ];

  buildInputs = [
    wayland-protocols
    wlroots
    libxkbcommon
    pixman
    udev
    libevdev
    libinput
    libGL
  ] ++ lib.optional xwaylandSupport libX11;

  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline ${lib.optionalString xwaylandSupport "-Dxwayland"} -Dman-pages --prefix $out install
    runHook postInstall
  '';

  /* Builder patch install dir into river to get default config
    When installFlags is removed, river becomes half broken.
    See https://github.com/riverwm/river/blob/7ffa2f4b9e7abf7d152134f555373c2b63ccfc1d/river/main.zig#L56
  */
  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/riverwm/river";
    description = "A dynamic tiling wayland compositor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    # maintainers = with maintainers; [ fortuneteller2k ];
  };
}

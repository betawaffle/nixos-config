{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "rapiddisk";
  name = "${pname}-${version}";
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "pkoutoupis";
    repo = pname;
    rev = version;
    sha256 = "sha256-aCFhexMX2SF/ryjc/xPc0h4IIhV1Fm9w4/38C9sHmUo=";
  };

  patches = [ ./makefile.patch ./module.patch ];

  sourceRoot = "source/module";
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "DESTDIR=$(out)"
  ];

  meta = with lib; {
    description = "A set of advanced Linux RAM Drive and Caching kernel modules.";
    homepage = "http://www.rapiddisk.org";
    license = licenses.gpl2;
    maintainers = [];
    platforms = platforms.linux;
  };
}

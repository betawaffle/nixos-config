{ stdenv
, fetchFromGitHub
, lib
}:

stdenv.mkDerivation rec {
  pname = "avra";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Ro5bert";
    repo = pname;
    rev = version;
    sha256 = "sha256-joOj89WZ9Si5fcu1w1VHj5fOcnB9N2313Yb29A+nCCY=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Assembler for the Atmel AVR microcontroller family";
    homepage = "https://github.com/Ro5bert/avra";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}

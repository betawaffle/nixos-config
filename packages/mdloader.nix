{ stdenv
, mdloader
}:

stdenv.mkDerivation {
  pname = "mdloader";
  version = mdloader.rev;
  src = mdloader;

  installPhase = ''
    mkdir -p $out/bin/
    mv build/* $out/bin/
  '';
}

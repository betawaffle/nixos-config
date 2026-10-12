
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # arduino

    avrdude
    avra
    minipro

    pkgsCross.avr.buildPackages.gcc
    pkgsCross.avr.buildPackages.bintools

    (stdenv.mkDerivation {
      name = "arduino-with-env";

      inherit arduino;

      nativeBuildInputs = [ makeWrapper ];

      buildCommand = ''
        mkdir -p $out/bin
        makeWrapper $arduino/bin/arduino $out/bin/arduino \
          --set "_JAVA_AWT_WM_NONREPARENTING" "1"
      '';
    })
  ];
}

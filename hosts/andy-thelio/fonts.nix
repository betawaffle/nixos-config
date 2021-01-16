{ lib, pkgs, ... }:
{
  # A better console font?
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  fonts.enableDefaultFonts = false;

  fonts.fonts = with pkgs; [
    fira
    fira-code
    fira-code-symbols

    font-awesome

    inter
    inter-ui

    iosevka
    iosevka-bin

    # nerdfonts
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "Iosevka" ];
    sansSerif = [ "Inter" ];
  };
}

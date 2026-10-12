{ lib, pkgs, ... }:
{
  fonts.enableDefaultFonts = true;

  fonts.fonts = with pkgs; [
    #fira
    #fira-code
    #fira-code-symbols

    font-awesome

    inter
    inter-ui

    # iosevka-bin
    # iosevka-bin-aile
    # iosevka-bin-curly
    # iosevka-bin-curly-slab
    # iosevka-bin-etoile
    # iosevka-bin-variants.slab

    nerdfonts #.override { fonts = [ "Iosevka" ]; })
  ];

  fonts.fontconfig.defaultFonts = {
    # monospace = [ "Iosevka Term Slab" "Iosevka" ];
    # sansSerif = [ "Iosevka Aile" ];
    # serif     = [ "Iosevka Etoile" ];
    # emoji     = [];
  };
}

{ lib
, iosekva-bin
}:

let
  inherit (lib) listToAttrs;

  mkVariant = name: {
    inherit name;
    value = iosevka-bin.override { variant = name; };
  };

  mkVariants = list: listToAttrs (map mkVariant list);
in

mkVariants [
  "aile"
  "curly"
  "curly-slab"
  "etoile"
  "slab"
]

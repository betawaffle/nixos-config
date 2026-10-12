let
  meta = builtins.listToAttrs (map metaFor names);

  metaFor = name: {
    inherit name;
    value = import ./${name}/meta.nix;
  };

  names = [
    "andy-mac-pro"
    "andy-thelio"
    "moneta"
    "router"
  ];
in
  meta
